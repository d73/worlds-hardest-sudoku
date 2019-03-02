# worlds-hardest-sudoku
World's Hardest Sudoku Puzzle (and Solution?)

## World's Hardest? Really?
According to [The Telegraph](https://www.telegraph.co.uk/news/science/science-news/9359579/Worlds-hardest-sudoku-can-you-crack-it.html), this is the world's hardest sudoku puzzle. The answer link on the website is broken, so I whipped up a quick program to figure out the answer.

## Solution
Aaaaaaand the solution is...  
```
$ perl sudoku.pl
Solved: 800000000003600000070090200050007000000045700000100030001000068008500010090000400
     -> 812753649943682175675491283154237896369845721287169534521974368438526917796318452
	8  |   |
	  3|6  |
	 7 | 9 |2
	---+---+---
	 5 |  7|
	   | 45|7
	   |1  | 3
	---+---+---
	  1|   | 68
	  8|5  | 1
	 9 |   |4

	812|753|649
	943|682|175
	675|491|283
	---+---+---
	154|237|896
	369|845|721
	287|169|534
	---+---+---
	521|974|368
	438|526|917
	796|318|452
```
