# frozen_string_literal: true

module Display
  def ask_new_or_load
    puts '- Enter 1 to start a new game'
    puts '- Enter 2 to load a saved game'
    respone = gets.chomp
    return 'load' if respone == '2'

    'new' if respone == '1'
  end

  def ask_which_save
    if Dir.exist?('saves')
      puts Dir.glob('saves/*').(map { |file| file[(file.index('/') + 1)...(file.index('.'))] })
      Dir.home
      gets.chomp
    else
      puts 'You did not save any games yet!'
    end
  end

  def display_hint(hint)
    formatted_hint = hint.chars.join(' ')
    puts formatted_hint
  end
end
