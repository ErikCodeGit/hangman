# frozen_string_literal: true

require 'yaml'
require_relative 'display'

class Game
  include Display
  def start_game
    response = ask_new_or_load
    case response
    when 'load'
      load_save(ask_which_save)
    when 'new'
      new_game
    end
    # save_game(ask_save_name)
  end

  private

  def new_game
    puts 'Starting new Game!'
    p @word = choose_random_word
    @hint = @word.gsub(/./, '_')
    @guesses = 12
    display_hint(@hint)
  end

  def save_game(fname)
    file = File.new("saves/#{fname}.yml", 'w')
    @info = { word: @word, hint: @hint, guesses: @guesses }
    file.write(@info.to_yaml)
  end

  def load_save(fname)
    if fname
      content = YAML.load(File.read("saves/#{fname}.yml"))
      begin
        @word = content[:word]
        @hint = content[:hint]
        @guesses = content[:guesses]
        puts 'Loaded file successfully!'
      rescue StandardError
        puts "Couldn't load from file!"
      end
    else
      new_game
    end
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
