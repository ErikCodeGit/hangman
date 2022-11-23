# frozen_string_literal: true

require 'yaml'
require_relative 'display'

class Game
  include Display

  MIN_WORD_LENGTH = 5
  MAX_WORD_LENGTH = 12

  def start_game
    init_variables
    display_welcome
    response = ask_new_or_load
    case response
    when 'load'
      load_save(ask_which_save)
    when 'new'
      new_game
    end
    start_player_guessing
  end

  private

  def init_variables
    @word = ''
    @hint = ''
    @lives = 0
    @correct_letters = []
    @false_letters = []
    @won = false
    @current_save = ''
  end

  def new_game
    display_game_start
    @word = choose_random_word
    @hint = @word.gsub(/./, '_')
    @lives = 8
  end

  def start_player_guessing
    until @lives.zero? || @won
      display_lives(@lives)
      display_hint(@hint)
      handle_guess
    end
    display_hint(@hint)
    if @won
      display_win
    else
      display_defeat(@word)
    end
    start_game if ask_play_again
  end

  def handle_guess
    guess = ask_letter
    if guess == '!save'
      save_game(ask_save_name)
    else
      eval_guess(guess)
      update_hint
      check_game_won
    end
  end

  def eval_guess(guess)
    if @correct_letters.include?(guess)
      display_already_guessed(guess)
    elsif @word.include?(guess)
      @correct_letters << guess
      display_right_guess(guess)
    else
      @false_letters << guess
      @lives -= 1
      display_wrong_guess(guess)
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

  def check_game_won
    return unless @hint == @word

    @won = true
    delete_save(@current_save) if @current_save != ''
  end

  def delete_save(fname)
    File.delete("saves/#{fname}.yml")
  end

  def save_game(fname)
    ensure_saves_dir_exist
    file = File.new("saves/#{fname}.yml", 'w')
    @info = { word: @word,
              hint: @hint,
              lives: @lives,
              correct_letters: @correct_letters,
              false_letters: @false_letters }
    file.write(@info.to_yaml)
    file.close
    @current_save = fname
    display_save_success
  end

  def ensure_saves_dir_exist
    return if Dir.exist?('saves')

    Dir.mkdir('saves')
  end

  def load_save(fname)
    if fname
      content = YAML.load(File.read("saves/#{fname}.yml")) # rubocop:disable Security/YAMLLoad
      begin
        update_info(content)
        @current_save = fname
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
    @lives = hash[:lives]
    @correct_letters = hash[:correct_letters]
    @false_letters = hash[:false_letters]
  end

  def choose_random_word
    File.open('google-10000-english-no-swears.txt', 'r') do |file|
      words = file.readlines
                  .map(&:strip)
                  .filter { |word| word.length.between?(MIN_WORD_LENGTH, MAX_WORD_LENGTH) }
      words.length
      return words[rand(words.length)]
    end
    'error'
  end
end
