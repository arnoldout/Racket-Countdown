#lang racket
(require data/queue)
(define l(list 1 1 -1 1 1 1 1 -1 -1 -1 -1))
;(define perms(list(permutations (list 1 1 1 1 1 -1 -1))))
(define q (make-queue))

(define start-perm (list -1 -1 -1 -1 1 1 1 1))

(define perms (remove-duplicates (permutations start-perm)))

(define (make-rpn l)
  (append (list 1 1) l (list -1)))

(make-rpn (car  perms))

(define lll(map make-rpn perms))
(define total (random 100 1000))
total
(define (isValidRPN expression [stack 0])
  (if(< stack 0)
     #f
     (if (null? expression)
         ;end of recursion, check state of stack, if 1 then expressin is valid RPN
         (if (= stack 1)
             #t
             #f)
         ;expression still has values, update stack and recursively call self with updated stack and cdr of expression
         (cond [(equal? (car expression)1)(isValidRPN (cdr expression) (+ stack 1))]
               [(equal? (car expression)-1)(isValidRPN (cdr expression) (- stack 1))]
               [else (isValidRPN (cdr expression) (stack))]
               ))))
(define (convertToValues binaryList values operands [mappedVals '()] )
  (if(null? binaryList)
     mappedVals
     (if(equal?(car binaryList)1)
        (convertToValues  (cdr binaryList) values operands (cartesianOnList values mappedVals))
        (convertToValues  (cdr binaryList) values operands (cartesianOnList operands mappedVals))
        )
  ))
(define  (cartesianOnList list value)
  (define a (cartesian-product list value))
  (define b(list 2 3))
  a)
(define (evaluateRPN expression [stack (make-queue)])
     (if (null? expression)
         (if (=(queue-length stack) 1)
             (if (equal?(dequeue! stack)total)
                 #t
                 #f)
         #f)
         (if (number? (car expression))
         (evaluateRPN (cdr expression) (enqueueAndReturn stack (car expression)))
         ;do rpn calculating, which also returns a boolean
         ;a true means that the calculation was valid
         ;a false means the calculation returned either a negative number or fraction, which is invalid
         (if (doRPN stack (car expression))
             (evaluateRPN (cdr expression) stack)
             #f))))

(define (enqueueAndReturn stack value)
  (enqueue-front! stack value)
  stack)
(define (doRPN stack oper)
  (define a (dequeue! stack))
  (define b (dequeue! stack))
  (define c (oper b a))
  (enqueue-front! stack c)
  ;checking if the calculated value is negative or a fraction
  (if (exact-nonnegative-integer? c)
      #t
      #f))
;(define qqq(filter isValidRPN lll));
;qqq
(define ff (list 3 5 + 7 2 - *))
(define fff (cons(list 3 5 + 7 9 * *) ff))
(define ffff (cons (list 3 1 + 7 9 - +)fff))
ffff
;(define g (list + - / *))
;(define exp (list list(3 5 + 7 2 - *))(list(3 5 + 7 9 * *))(list(3 1 + 7 9 - +)))
;(convertToValues l ff g)
;(evaluateRPN ff)
(define qqqq(evaluateRPN ff))
qqqq


