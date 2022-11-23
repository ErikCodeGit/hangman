# frozen_string_literal: true

module Display
  def display_hr
    puts Array.new(50, '-').join
  end

  def display_welcome
    display_hr
    puts "Welcome to Hangman!"
    display_hr
  end

  def ask_new_or_load
    puts '- Enter 1 to start a new game'
    puts '- Enter 2 to load a saved game'
    respone = gets.chomp
    display_hr
    return 'load' if respone == '2'

    'new' if respone == '1'
  end

  def ask_which_save
    if Dir.exist?('saves')
      file_names = Dir.glob('saves/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))] }
      puts 'Your saved games:'
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
      display_hr
      return false
    end
    display_hr
  end

  def display_hint(hint)
    formatted_hint = hint.chars.join(' ')
    puts formatted_hint
    puts
  end

  def ask_save_name
    puts 'Enter the name for your save: '
    gets.chomp
  end

  def ask_letter
    print 'Enter your guess: '
    response = ''
    loop do
      response = gets.chomp
      return response if response == '!save'
      break if response.length == 1 && response.match?(/[a-zA-Z]/)

      puts 'Invalid guess, only enter single letters:'
    end
    display_hr
    response.downcase
  end

  def display_guesses(guesses)
    puts "You have #{guesses} guesses left!"
  end

  def display_game_start
    puts 'Starting new Game!'
    display_hr
  end

  def display_load_success
    puts 'Loaded file successfully!'
  end

  def display_load_error
    puts "Couldn't load from file!"
  end

  def display_save_success
    puts 'Saved file successfully!'
  end

  def display_win
    puts 'You guessed the word correctly!'
    display_hr
  end

  def display_defeat(word)
    puts "You ran out of guesses! The word was '#{word}'"
    display_hr
  end

  def ask_play_again
    puts 'Do you wish to play again?'
    puts "- Enter 'y' to play again, anything else to quit"
    response = gets.chomp
    display_hr
    return true if response.downcase[0] == 'y'

    false
  end
end
