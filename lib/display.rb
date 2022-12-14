# frozen_string_literal: true

module Display
  def display_hr
    puts Array.new(50, '-').join
  end

  def display_welcome
    display_hr
    puts 'Welcome to Hangman!'
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
    return_value = false
    if !Dir.exist?('saves')
      puts 'You did not save any games yet!'
      Dir.mkdir('saves')
    elsif Dir.glob('saves/*'.empty?)
      puts 'You do not have any saved games!'
    elsif Dir.exist?('saves')
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
      return_value = fname
    end
    display_hr
    return_value
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
    print "Enter your guess ('!save' to save): "
    response = ''
    loop do
      response = gets.chomp
      break if (response.length == 1 && response.match?(/[a-zA-Z]/)) || response == '!save'

      puts 'Invalid guess, only enter single letters:'
    end
    display_hr
    response.downcase
  end

  def display_lives(lives)
    puts "You have #{lives} lives left!"
  end

  def display_game_start
    puts 'Starting new Game!'
    display_hr
  end

  def display_load_success
    puts 'Loaded file successfully!'
    display_hr
  end

  def display_load_error
    puts "Couldn't load from file!"
    display_hr
  end

  def display_save_success
    puts 'Saved file successfully!'
    display_hr
  end

  def display_win
    puts 'You guessed the word correctly!'
    display_hr
  end

  def display_defeat(word)
    puts "You ran out of lives! The word was '#{word}'"
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

  def display_right_guess(guess)
    print "'#{guess}' is Correct! "
  end

  def display_wrong_guess(guess)
    print "'#{guess}' is Wrong! "
  end

  def display_already_guessed(guess)
    print "You already tried '#{guess}'! "
  end
end
