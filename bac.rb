module BullsAndCows
  class Game
    def initialize
      @attempts = 0
      welcome
      instructions
      choose_to_play
      choose_word
      puts yellow("--------------------------------")
      puts yellow("You have chosen the word: " + @secret_word)
      puts yellow("--------------------------------")
      puts "Started at:" + Time.now().to_s
      play_game
      quit_game
    end

    def welcome
      system "clear"
      puts green("##########################################")
      puts green("##  Welcome to the Bulls and Cows game! ##")
      puts green("##########################################")
    end

    def instructions
      puts " "
      puts "First you have to choose a four-letter word."
      puts "The word to be guessed should not have repeating letters."
      puts "Only letters are allowed!"
      puts " "
      puts "The computer then will guess the word."
      puts " "
      puts green("Would you like to play? (y/n)")
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
        @secret_word = input
      else
        input.clear
        choose_word
      end
    end

    def choose_word_input_validation(response)
      if response.length != 4
        puts red("Invalid input: wrong length.")
        return false
      end
      if !response.match(/^[[:alpha:]]+$/)
        puts red("Invalid input: only letters accepted.")
        return false
      end
      if !(response !~ /([a-z]).*\1/)
        puts red("Invalid input: letters cannot be reapeted.")
        return false
      end
      return true
    end

    def colorize(text, color_code)
      "\e[#{color_code}m#{text}\e[0m"
    end

    def red(text); colorize(text, 31); end
    def green(text); colorize(text, 32); end
    def blue(text); colorize(text, 34); end
    def yellow(text); colorize(text, 33); end

    def print_cows_bulls(input)
      puts "cows  = " + yellow(input[1].to_s) + " - bulls = " + green(input[0].to_s)
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
      puts "All possibilities = " + possibilities.length.to_s

      loop do
        computer_guess = make_guess(possibilities)
        check = compare(secret_word, computer_guess)

        puts "****"
        puts "Attempt no. " + @attempts.to_s + " = " + yellow(computer_guess.join.to_s)
        print_cows_bulls(check)

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

        puts "possibilities = " + possibilities.length.to_s
        puts "Time: " + Time.now().to_s

        if have_a_match?(check)
          puts green("Woohay!!!!!  We found it!!!")
          break
        end

        break if @attempts == 36
      end

      puts "** END **"
    end #def play_game
  end # class Game
end #module BullsAndCows

BullsAndCows::Game.new
