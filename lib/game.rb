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
  end

  private

  def new_game
    p @word = choose_random_word
    p @hint = @word.gsub(/./, '_')
    display_hint(@hint)
  end

  def save_game(fname)
    @info = { word: @word, hint: @hint, guesses: @guesses }
    File.open(fname) { |file| file.write(@info.to_yaml) }
  end

  def load_save(fname)
    content = YAML.safe_load(File.read(`"#{fname}".yml`))
    @word = content[:word]
    @hint = content[:hint]
    @guesses = content[:guesses]
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
