# Coding Challenge
 
Write a command line program in ruby that accurately and efficiently guesses the word in 4 letter word Cows and Bulls game.
 
## Word Bulls and Cows 

Players: Two - Also known as: Word Mastermind

Players take turns in trying to guess each other's word.

## Description

One player, the Chooser, thinks of a four-letter word and the other player, the Guesser, tries to guess it.

At each turn the Guesser tries a four-letter word, and the Chooser says how close it is to the answer by giving:

The number of Bulls - letters correct in the right position.
The number of Cows - letters correct but in the wrong position.
The Guesser tries to guess the answer in the fewest number of turns.

The word to be guessed should not have repeating letters. Example, BOOK, TILT, KICK, BASS etc. are not allowed.

## Example
For example, if the Chooser has thought of the word LOVE the replies for some guesses are as follows:

| Turn | My guess | Bulls | Cows |
|:----:|:--------:| :----:|:----:|
| 1.   | FISH     | 0     | 0 |
| 2.   | VAIN     | 0     | 1 |
| 3.   | LANE     | 2     | 0 |
| 4.   | VILE     | 1     | 2 |
| 5.   | LOVE     | 4     | 0 |

Essentially, your program is the "Guesser" in the description of the game above. Your algorithm guesses the word, while the Chooser (human) gives the cows and bulls score for each guess using command line.
 