# frozen_string_literal: true

require 'yaml'
require_relative 'display'

class Game
  include Display

  def initialize
    @word = ''
    @hint = ''
    @guesses = 0
    @correct_letters = []
    @false_letters = []
  end

  def start_game
    response = ask_new_or_load
    case response
    when 'load'
      load_save(ask_which_save)
    when 'new'
      new_game
    end
    start_player_guessing
    # save_game(ask_save_name)
  end

  private

  def new_game
    display_game_start
    p @word = choose_random_word
    @hint = @word.gsub(/./, '_')
    @guesses = 12
  end

  def start_player_guessing
    until @guesses.zero?
      display_guesses(@guesses)
      display_hint(@hint)
      handle_guess
    end
  end

  def handle_guess
    guess = ask_letter
    if guess == '!save'
      save_game(ask_save_name)
    else
      eval_guess(guess)
      update_hint
      @guesses -= 1
    end
  end

  def eval_guess(guess)
    if @word.include?(guess)
      @correct_letters << guess
    else
      @false_letters << guess
    end
  end

  def update_hint
    @hint = @word.chars.map do |char|
      if @correct_letters.include?(char)
        char
      else
        '_'
      end
    end.join
  end

  def save_game(fname)
    file = File.new("saves/#{fname}.yml", 'w')
    @info = { word: @word,
              hint: @hint,
              guesses: @guesses,
              correct_letters: @correct_letters,
              false_letters: @false_letters }
    file.write(@info.to_yaml)
    display_save_success
  end

  def load_save(fname)
    if fname
      content = YAML.load(File.read("saves/#{fname}.yml")) # rubocop:disable Security/YAMLLoad
      begin
        update_info(content)
        display_load_success
      rescue StandardError
        display_load_error
      end
    else
      new_game
    end
  end

  def update_info(hash)
    @word = hash[:word]
    @hint = hash[:hint]
    @guesses = hash[:guesses]
    @correct_letters = hash[:correct_letters]
    @false_letters = hash[:false_letters]
  end

  def choose_random_word
    File.open('google-10000-english-no-swears.txt', 'r') do |file|
      words = file.readlines.map(&:strip).filter { |word| word.length.between?(5, 10) }
      words.length
      return words[rand(words.length)]
    end
    'error'
  end
end
