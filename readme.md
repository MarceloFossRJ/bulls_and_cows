## Word Bulls and Cows

Word Bulls and Cows is two player game also known as Word Mastermind.  
The players take turns in trying to guess each other's word.

## Description

One player, the Chooser, thinks of a four-letter word and the other player, the Guesser, tries to guess it.

At each turn the Guesser tries a four-letter word, and the Chooser says how close it is to the answer by giving:

The number of Bulls - letters correct in the right position.
The number of Cows - letters correct but in the wrong position.
The Guesser tries to guess the answer in the fewest number of turns.

The word to be guessed should not have repeating letters. Example, BOOK, TILT, KICK, BASS etc. are not allowed.

## Example
If the Chooser has thought of the word LOVE the replies for some guesses are as follows:

| Turn | My guess | Bulls | Cows |
|:----:|:--------:| :----:|:----:|
| 1.   | FISH     | 0     | 0 |
| 2.   | VAIN     | 0     | 1 |
| 3.   | LANE     | 2     | 0 |
| 4.   | VILE     | 1     | 2 |
| 5.   | LOVE     | 4     | 0 |


In the current program, the computer is the "Guesser".  
There are two gameplay options:  
1. The game algorithm guesses the word, while the Chooser (human) gives the cows and bulls score for each guess using command line.
2. the Chooser (human) selects a word and the game algorithm does the rest of the job automatically.

## Installation instructions
Clone the repository on your computer.  
To run it type ``` $ ruby bac.rb ``` at command prompt, and follow the on screen instructions.

## Implementation details
The game was developed using ruby 2.3.1 on OSX El Capitan.  
The second gameplay option was not the initial goal, but was developed first with the intent to validate the algorithm, in the end I decided to keep it if the user wants to see it running.

Have fun!