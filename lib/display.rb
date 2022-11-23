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
      file_names = Dir.glob('saves/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
      puts(file_names.map { |fname| "- #{fname}" })
      puts 'Which save do you want to load?'
      fname = ''
      loop do
        fname = gets.chomp
        break if file_names.include?(fname)

        puts 'Please enter a valid filename!'
      end
      fname
    else
      puts 'You did not save any games yet!'
      Dir.mkdir('saves')
      false
    end
  end

  def display_hint(hint)
    formatted_hint = hint.chars.join(' ')
    puts formatted_hint
  end

  def ask_save_name
    puts "Enter the name for your save: "
    gets.chomp
  end
end
