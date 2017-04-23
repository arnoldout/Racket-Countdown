#lang racket
(require data/queue)


;Generate a random number between 101 and 999
;stored as total, the target number the algorithm needs to hit
(define total (random 101 1000))
;print out the generated total
total
;list of possible numbers, 6 numbers will be selected at random from this list
(define possibleVals(list 1  1  2  2  3  3  4  4  5  5  6  6  7  7  8  8  9  9  10  10  25  50 75 100))
;list of the available operands
(define operands (list + - * /))

;shuffle the possible list values, and return a list of 6 possible elements
(define (randomList expression)
  (take (shuffle expression) 6))

;create call randomList on the possible Values list, and store the returned list as generatedVals 
(define generatedVals (randomList possibleVals))
generatedVals

;function that takes an incomplete list of 1s and -1s, indicative of numbers or operators respectively,
;and append two 1s to the front, and a -1 to the back of l
;this will create a possibly valid RPN value structure
(define (make-rpn l)
  (append (list 1 1) l (list -1)))

;function that checks a list of 1s and -1s, to see if the function can possibly return a single number
(define (isValidRPN expression [stack 0])
  ;if the value in the stack is ever below 0, exit the function
  ;the stack is subtracted on every -1, and so if too many -1s are in order, can make the stack negative
  ;i.e. an invalid RPN structure
  (if(< stack 0)
     #f
     (if (null? expression)
         ;end of recursion, check state of stack, if stack value is 1 then expressin is valid RPN
         ;other wise there will be too many items in the stack when evaluating with real values
         (if (= stack 1)
             #t
             #f)
         ;expression still has values, update stack and recursively call self with updated stack and cdr of expression
         ;if value is 1, icrement stack, if value is -1, decrement stack 
         (cond [(equal? (car expression)1)(isValidRPN (cdr expression) (+ stack 1))]
               [(equal? (car expression)-1)(isValidRPN (cdr expression) (- stack 1))]
               [else (isValidRPN (cdr expression) (stack))]
               ))))


;function to remove first instance of value from list
;works similar to remove*, except that it only removes 1 instance of that value from the list
(define (removeListItems listA listB)
  (if (null? listA)
      listB
      (removeListItems(cdr listA)(remove (car listA) listB))))

;function that takes a list of numbers and operands, and attempts to use Reverse Polish Notation to evaluate the expression
;when hitting this function, the RPN expression should be in the correct format, but may still evaluate to an invalid value

;Parameters - expression: The list of numbers and operands
;           - stack: A queue that stores the numbers during operations, and is popped twice when an operand is found 
(define (evaluateRPN expression [stack (make-queue)])
  ;remove unnecessary brackets from expression
  (set! expression (flatten expression))
  ;if expression is empty
  (if (null? expression)
      ;if queue has 1 value left and it is equal to the total, then return true
      ;any other outcome will return false
      (if (=(queue-length stack) 1)
          (if (equal?(dequeue! stack)total)
              #t
              #f)
          #f)
      ;add number to stack if value is a number, process RPN if value is a procedure
      (if (number? (car expression))
          (evaluateRPN (cdr expression) (enqueueAndReturn stack (car expression)))
          ;failsafe to ensure RPN procedure has 2 elements to dequeue
          (if (<(queue-length stack) 2)
              #f
              ;do rpn calculating, which also returns a boolean 
              ;a true means that the calculation was valid
              ;a false means the calculation returned either a negative number or fraction, which is invalid
              (if (doRPN stack (car expression))
                  (evaluateRPN (cdr expression) stack)
                  #f)))))


(define (singleOneCartesian li evalType [vals '()])
  (if (null? li)
     vals
     (if(equal? evalType 1)
         (if (pair?(flatten (car li)))
             (singleOneCartesian(cdr li) evalType (append (navoo li vals) vals))
             (singleOneCartesian(cdr li) evalType (append (cartesian-product (list (car li))(remove (car li) generatedVals))vals)))
         
         (singleOneCartesian(cdr li) evalType (append (cartesian-product (list(flatten (car li)))operands)vals))
         )
         ))
;might be adding vals too early
(define (navoo li vals)
  (define u(flatten (car li)))
  (define v generatedVals)
  (define g(removeListItems u generatedVals))
  (define n (cartesian-product (list(car li))g))
  n
  )

(define (cartesianValues evalList [vals '()])
  (define li generatedVals)
  (if (null? evalList)
      (map outputExpression(filter evaluateRPN vals))
      (if (empty? vals)
      (cartesianValues (cdr (cdr evalList)) (singleOneCartesian li (car evalList))) 
      (cartesianValues (cdr evalList) (singleOneCartesian vals (car evalList))))))

(define (outputValidExpression li [stack '()])
  (if (null? li)
      (displayln stack)
      (if (procedure? (car li))
          (outputValidExpression (cdr li)(append stack (list (operandSwitch (car li)))))
          (outputValidExpression (cdr li)(append stack (list (car li)))))))
(define (outputExpression expression)
   (set! expression (flatten expression))
  (if (number? (car expression))
      (outputValidExpression expression)
       #f))
      

(define (operandSwitch operand)
  (define val(operand 8 4))
  (cond
    [(equal? val 12)'+]
    [(equal? val 4)'-]
    [(equal? val 32)'*]
    [(equal? val 2)'/]))


  
(define (enqueueAndReturn stack value)
  (enqueue-front! stack value)
  stack)

(define (doRPN stack oper)
  (define a (dequeue! stack))
  (define b (dequeue! stack))
  (define c (oper b a)) 
  (enqueue-front! stack c)
  ;checking if the calculated value is negative or a fraction
  (if (and (exact-nonnegative-integer? c) (not(zero? c)))
      #t
      #f))

;calling the permutations function on a list of 1s and -1s
;it then calls the remove-Duplicates function which takes out any identical lists
;make-rpn is then called, and a -1 is added to the end, and two 1s are added to the front of evert permutation
;every permutation
(define storeValues(map cartesianValues (filter isValidRPN(map make-rpn(remove-duplicates (permutations (list 1 1 1 1 -1 -1 -1 -1)))))))
(quote "Computation Complete")