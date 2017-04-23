# Racket-Countdown
A Racket script for playing the numbers game on Channel 4's Countdown.
In the game players are given 6 numbers, from the list [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 25, 50, 75, 100]
and a randomized Total number is generated between 101 and 999.

Players have to use the 6 numbers and any of the basic arithmetic operands: + * - /
They need to use these basic rules to make the generated Total.

## The Project

To run the program, you should open the Countdown.rkt file in DrRacket, and press Run. 
The program will generate a randomized total, which it will print to the screen, and then it will generate 6 random values from the list outlined above. This will also be displayed to the screen, directly below the total.
The program will then begin to generate all the possible arithmetic expressions and evaluate them. As they are evaluated, any that equal the total will be displayed on the screen. An example of one of these valid expressions will look like this:
(4 8 100 75 10 7 * - + + *)
Once all valid equations have been selected and printed to the screen the user will be informed that the "Computation is Complete"

## Algorithm
### Removing invalid syntax
The basis of the algorithm stems from an idea from our lecturer. His idea was to use Reverse Polish Notation as a fast way to evaluate large amounts of equations. The specific syntax of Reverse Polish Notation allowed itself to be manipulated, so that I could discard large amounts of possible equations simply because they were not valid Reverse Polish Notation equations. Our lecturer showed us a way of using a list of dummy data, such as 1s and -1s, that equationally would work as placeholders for actual values later. For example, a 1 would be mapped to a real number, and a -1 would be mapped to an operand. This system allowed me to check the syntax of an equation to be of valid Reverse Polish Notation without actual values. For example, Reverse Polish Notation cannot start with an operand, but must end with one, or at the end of equating, there should only be one value left on the stack. 
Using this knowledge, I was able to generate all of the permutations of a list of 1s and -1s, and very quickly discarded a large portion of those. What remained was a list of a list of 1s and -1s. Each one was now of valid Reverse Polish Notation syntax. 

### Replacing with actual values
The next step was to take a list such as (1 1 1 1 -1 -1 -1 1 1 -1 -1) and swap out any 1s for all the possible real values and any -1s for all the possible operands. Of course the rules of the game meant that once a number was used, it could no longer be used again. My approach for this was to use the cartesian product function. I wrote a function singleOneCartesian that takes a value evalType which will either be a 1 or a -1, and it also has an optional parameter vals, which be slowly storing the cartesian products as they are added. Initally however it will just be an empty list.

The easiest way to explain how this part of the algorithm works is through two loops of the function. For this example I will be using a smaller list of only 3 numbers, these are 4,8,10. It doesn't matter to the function how manu numbers are passed to it, it will cope just fine.
On first iteration, the cartesian-product will be called on every combination of 2 numbers from those generated for us. This creates a large list of lists. Each list will have a different combination of 2 numbers. Such as ((4,8), (4,10), (8,10)). This function calls itself again, but now passing the generated list to itself as the optional parameter vals. On second iteration these I take each sublist, such as (4,8), and the original list, 4,8,10, I remove the values 4 and 8 from the original list, so it now only has 10. I then get the cartesian product of 4,8 and 10. Which will just return (4,8,10) in this example, but will create much more values with a larger data set.
If instead the next number is -1, I will get the cartesian-product of (4,8) and all of the valid operands (+,/,*,-). By doing this for every sublist in vals, I slowly build up a huge list of numbers and operands that fit the template of 1s and -1s. Once a single list of 1s and -1s has been successfully replaced with all the possible numbers and operators, I use the map function to evaluate each expression that was generated from a single list of 1s and -1s. Each list of 1s and -1s will undergo the same procedure until all lists of 1s and -1s have been converted to cartesian lists.

### Evaluation
My evaluation function implements a queue named stack, it self recurses through an expression list, such as (1 2 3 4 + + +). When it sees a number, it will add the values to the front of the queue. When it sees an operand, it will pop 2 numbers from the queue, evaluate the expression and place the answer to the front of the queue. If the answer is not a valid value within the rules of the game, such as  a decimal, the evalation function immediatly returns #f. At the end of an expression, the queue is checked to see if the value is positive, and if there is only one value left. If both are true, and the final remaining value is equal to the total, a #t is returned. Any other outcome returns #f. By only ever returning a #t or #f, I can use the filter method to narrow down the large number of cartesian products to only expressions that equate to the total.

## Output
The filter method used to wittle down all the expressions to only those that equate the total, returns a large list of expressions. I use the map function on that list, and output all of the remaining expressions to the user. I found it was best to do the printing here, as at this point, the heap space is considerably large but if I were to wait until all of the possibilities were generated, the computer would likely crash. By doing this it allows Racket to forget about the all of the values it has just generated once they've been output.
At this point, the operands are in a non human readible syntax such as #<procedure:+>. To make it more readible, I self recurse over the ouput list, and if the value is a procedure, I use it in a quick expression. By using it as a function, with 8 and 4, I can determine what type of procedure it is. For example a 8-4 equals 4, or 8*4 equals 32. Depending on the outcome of the equation, I return a more human readible *, +,- or /.

Each valid expression is then printed on a new line and looks like the following: (4 8 100 75 10 7 * - + + *)

