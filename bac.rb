module BullsAndCows
  class Game
    def initialize
      welcome
      instructions
      choose_to_play
      choose_word
      puts "You have chosen the word:" + @chosen_word
      puts "---------------------------------"
    end

    def welcome
      system "clear"
      puts "##########################################"
      puts "##  Welcome to the Bulls and Cows game! ##"
      puts "##########################################"
    end

    def instructions
      puts " "
      puts "First you have to choose a four-letter word."
      puts "The word to be guessed should not have repeating letters."
      puts "Only letters are allowed!"
      puts " "
      puts "The computer then will guess the word."
      puts " "
      puts "------------------------------------------"
      puts " "
      puts "Would you like to play? (y/n)"
    end

    def choose_to_play
      chooser = gets.chomp.downcase
      choose_to_play_input_validation(chooser)
    end

    def choose_to_play_input_validation(response)
      if response == "y"
        return
      elsif response == "n"
        quit_game
      else
        puts "Input not valid, please choose y or n"
        choose_to_play
      end
    end

    def quit_game
      puts "Thank you, see you next time!"
    end

    def choose_word
      puts " "
      puts "Choose now a four-letter word, with non repeting letters:"

      input = gets.chomp.downcase
      if choose_word_input_validation(input)
        @chosen_word = input
      else
        input.clear
        choose_word
      end
    end

    def choose_word_input_validation(response)
      if response.length != 4
        puts "Invalid input: wrong length."
        return false
      end
      if !response.match(/^[[:alpha:]]+$/)
        puts "Invalid input: only letters accepted."
        return false
      end
      if !(response !~ /([a-z]).*\1/)
        puts "Invalid input: letters cannot be reapeted."
        return false
      end
      return true
    end

  end
end

BullsAndCows::Game.new
