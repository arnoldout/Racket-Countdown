#lang racket
(require data/queue)

(define generatedVals(list 3 5 7 2 4 1))
(define operands (list + - * /))
(define (make-rpn l)
  (append (list 1 1) l (list -1)))

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


(define (cart li evalType [vals '()])
  (if (null? li)
     vals
     (if(equal? evalType 1)
         (if (pair?(car li))
             (cart(cdr li) evalType (append (cartesian-product (list(flatten (car li)))(remove* (flatten (car li))generatedVals))vals))
             (cart(cdr li) evalType (append (cartesian-product (list (car li))(remove (car li) generatedVals))vals)))
         
         (cart(cdr li) evalType (append (cartesian-product (list(flatten (car li)))operands)vals))
         )
         ))



(define (cartManager evalList [vals '()])
  (define li generatedVals)
  (if (null? evalList)
      vals
      (if (empty? vals)
      (cartManager (cdr evalList) (append(cart li (car evalList))vals))    
      (cartManager (cdr evalList) (append(cart vals (car evalList))vals)))))


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

;(define perms(list(permutations (list 1 1 1 1 1 -1 -1))))
(define start-perm (list -1 -1 -1 -1 1 1 1 1))

(define perms (remove-duplicates (permutations start-perm)))

(make-rpn (car  perms))

(define lll(map make-rpn perms))
(define llll (map cartManager lll))

(define total (random 100 1000))

;(define qqqq(map evaluateRPN llll))
;qqqq