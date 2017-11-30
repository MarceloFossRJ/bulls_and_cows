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
    end
    def choose_display
      puts @colors.green("Please choose one option:")
      puts @colors.green("1. Would you like to play yourself?")
      puts @colors.green("2. Would you like the computer play for you?")
      puts @colors.green("3. Would you like to quit?")
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

  class Matrix
    def permutations(pegs)
      [*'a'..'z'].permutation(pegs).map {|c| Array.new(c)}
    end

    def compare(reference, comparable)
      bulls = comparable.zip(reference).find_all { |a, b| a==b }.count
      cows = comparable.inject(0){|sum,e| (reference.include?(e)) ? sum += 1 : sum } - bulls
      Array.new([bulls,cows])
    end

    def make_guess(possibilities)
      possibilities.sample
    end
  end

  class Game
    PEGS = 4

    def initialize
      @ui = GameUI.new
      @attempts = 0
      @matrix = Matrix.new
      @compute = Compute.new

      @ui.welcome
      @ui.instructions
      @ui.choose_display
      choose_to_play
      choose_word if !@human_play
      @human_play ? human_play : computer_play
      @ui.quit_game
    end

    def choose_to_play
      chooser = gets.chomp.downcase
      choose_to_play_input_validation(chooser)
    end

    def choose_to_play_input_validation(response)
      if response == "1"
        @human_play = true
      elsif response == "2"
        @human_play = false
      elsif response == "3"
        quit_game
      else
        @ui.display_error "Input not valid, please choose 1,2 or 3"
        choose_to_play
      end
    end

    def quit_game
      @ui.quit_game
      exit!
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
      @ui.word_display(@secret_word)
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

    def validate_check_input(input)
      if !((0..4) === input)
        false
      else
        true
      end
    end

    def make_guess(possibilities)
      @attempts += 1
      @matrix.make_guess(possibilities)
    end

    def human_play
      possibilities = @matrix.permutations(PEGS)
      @ui.display_msg "Total initial possibilities = " + possibilities.length.to_s

      loop do
        computer_guess = make_guess(possibilities)
        @ui.display_msg "My guess no." + @attempts.to_s + " is: " + computer_guess.join.to_s
        check = Array.new
        @ui.display_msg "How many bulls I got?"
        check[0] = gets.chomp.to_i
        @ui.display_msg "How many cows I got?"
        check[1] = gets.chomp.to_i

        possibilities = @compute.iterate(check, possibilities, computer_guess)

        if @compute.have_a_match?(check)
          @ui.display_victory
          break
        elsif possibilities.length == 0
          @ui.display_error "Something went wrong, gotta out of possibilities, check if your bulls and cows input was correct."
          break
        end
      end
    end # human_play

    def computer_play
      @ui.display_time("Started at: ")
      secret_word = @secret_word.scan /\w/
      possibilities = @matrix.permutations(PEGS)
      @ui.display_msg "Total initial possibilities = " + possibilities.length.to_s
      @ui.display_board_header

      loop do
        computer_guess = make_guess(possibilities)
        check = @matrix.compare(secret_word, computer_guess)

        possibilities = @compute.iterate(check, possibilities, computer_guess)

        @ui.display_board_row(@attempts, computer_guess.join.to_s, check, possibilities.length.to_s)

        if @compute.have_a_match?(check)
          @ui.display_board_bottom
          @ui.display_victory
          break
        end
      end #end loop
    end #def computer_play
  end #End class Game

  class Compute
    def initialize
      @attempts = 0
      @ui = GameUI.new
      @matrix = Matrix.new
    end

    def have_a_match?(guess)
      guess[0] == 4
    end

    def iterate(check, possibilities, computer_guess)
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
        @matrix.compare(computer_guess,s) == check
      end
      possibilities
    end

  end # class Compute
end #module BullsAndCows

BullsAndCows::Game.new
