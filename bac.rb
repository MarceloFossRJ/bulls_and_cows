module BullsAndCows
  class Game
    def initialize
      welcome
      instructions
      choose_to_play
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
        puts "ok"
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
  end
end

BullsAndCows::Game.new
