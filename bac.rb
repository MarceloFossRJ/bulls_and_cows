module BullsAndCows
  class Timer
    def time
      t = Time.now
      t.strftime("%H:%M:%S").to_s
    end
  end

  class Colors
    def colorize(text, color_code)
      "\e[#{color_code}m#{text}\e[0m"
    end

    def red(text); colorize(text, 31); end
    def green(text); colorize(text, 32); end
    def blue(text); colorize(text, 34); end
    def yellow(text); colorize(text, 33); end
  end

  class GameUI
    def initialize
      @colors = Colors.new
      @time = Timer.new
    end
    def welcome
      system "clear"
      puts @colors.green("┌────────────────────────────────────────────┐")
      puts @colors.green("│     Welcome to the Bulls and Cows game!    │")
      puts @colors.green("└────────────────────────────────────────────┘")
    end
    def instructions
      puts "Instructions:"
      puts "Please choose a four-letter word with non repeating characters."
      puts "Only letters are allowed!"
      puts "The computer then will guess the word."
      puts "\n"
      puts @colors.green("Would you like to play? (y/n)")
    end
    def word_display(msg)
      puts @colors.yellow("You have chosen the word: " + msg)
    end
    def quit_game
      puts @colors.green("Thank you, see you next time!")
    end
    def display_time(prefix = ">")
      puts prefix + @time.time
    end
    def display_victory
      puts @colors.green("Woohay!!!!!  We found it!!!")
      display_time "Finished at: "
    end
    def display_error(msg)
      puts @colors.red(msg)
    end
    def display_board_header
      puts ("┌─────────┬───────┬──────┬───────┬─────────┐")
      puts ("│ Attempt │ Guess │ Cows │ Bulls | Possib. |")
      puts ("├─────────┼───────┼──────┼───────┼─────────┤")
    end
    def display_board_row(attempts, guess, input, possibilities)
      puts "│ " + attempts.to_s.ljust(7, ' ') + " │ " + guess.to_s.ljust(6, ' ') + "│ " + @colors.yellow(input[1].to_s.ljust(5, ' ')) + "│ " + @colors.green(input[0].to_s.ljust(6, ' ')) + "│ " + possibilities.to_s.ljust(8, ' ') + "│ "
    end
    def display_board_bottom
      puts ("└─────────┴───────┴──────┴───────┴─────────┘")
    end
    def display_choose_word
      puts "Choose your secret word now:"
    end
    def display_msg(msg)
      puts msg
    end
  end #end class GameUI

  class Game
    def initialize
      @attempts = 0
      @ui = GameUI.new
      @ui.welcome
      @ui.instructions
      choose_to_play
      choose_word
      @ui.word_display(@secret_word)
      @ui.display_time("Started at: ")
      play_game
      @ui.quit_game
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
        @ui.display_error "Input not valid, please choose y or n"
        choose_to_play
      end
    end

    def quit_game
      @ui.quit_game
    end

    def choose_word
      @ui.display_choose_word
      input = gets.chomp.downcase
      if choose_word_input_validation(input)
        @secret_word = input
      else
        input.clear
        choose_word
      end
    end

    def choose_word_input_validation(response)
      if response.length != 4
        @ui.display_error("Invalid input: wrong length.")
        return false
      end
      if !response.match(/^[[:alpha:]]+$/)
        @ui.display_error("Invalid input: only letters accepted.")
        return false
      end
      if !(response !~ /([a-z]).*\1/)
        @ui.display_error("Invalid input: letters cannot be reapeted.")
        return false
      end
      return true
    end

    def all_possibilities(pegs)
      [*'a'..'z'].permutation(pegs).map {|c| Array.new(c)}
    end

    def compare(reference, comparable)
      bulls = comparable.zip(reference).find_all { |a, b| a==b }.count
      cows = comparable.inject(0){|sum,e| (reference.include?(e)) ? sum += 1 : sum } - bulls
      Array.new([bulls,cows])
    end

    def make_guess(possibilities)
      @attempts += 1
      possibilities.sample
    end

    def have_a_match?(guess)
      guess[0] == 4
    end

    def play_game
      secret_word = @secret_word.scan /\w/
      pegs = 4
      possibilities = all_possibilities(pegs)
      @ui.display_msg "Total initial possibilities = " + possibilities.length.to_s
      @ui.display_board_header

      loop do
        computer_guess = make_guess(possibilities)
        check = compare(secret_word, computer_guess)

        #1.First try to reduce the possibilities the most
        #1.1if no bulls or cows in the guess remove all combinations with the letters in the guess from the possibilities set
        if check[1] == 0 && check[0] == 0
          computer_guess.map{ |j| possibilities.delete_if{|x| x.include? j} }
        end
        #1.2there is a bull or cow in the guess, we should remove from the possibilities the combinations that does not have any of those words
        n2 = Array.new
        if check[1] > 0 || check[0] > 0
          n2 = computer_guess.inject([]){|a,b| a += possibilities.select{|x| x.include? b } }
          possibilities = n2.uniq
        end
        #2. Apply inspired Knuth algorithm
        possibilities.select! do |s|
            compare(computer_guess,s) == check
        end

        @ui.display_board_row(@attempts, computer_guess.join.to_s, check, possibilities.length.to_s)

        if have_a_match?(check)
          @ui.display_board_bottom
          @ui.display_victory
          break
        end

        break if @attempts == 36
      end #end loop
    end #def play_game
  end # class Game
end #module BullsAndCows

BullsAndCows::Game.new
