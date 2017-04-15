#lang racket
(require data/queue)


;(define total (random 100 1000))
(define total 22)
(define generatedVals(list 3 5 7 4 2 1))
(define operands (list + - * /))
total

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




(define (evaluateRPN expression [stack (make-queue)])
  (set! expression (flatten expression))
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
         (if (pair?(flatten (car li)))
             (cart(cdr li) evalType (append (navoo li vals) vals))
             (cart(cdr li) evalType (append (cartesian-product (list (car li))(remove (car li) generatedVals))vals)))
         
         (cart(cdr li) evalType (append (cartesian-product (list(flatten (car li)))operands)vals))
         )
         ))
;might be adding vals too early
(define (navoo li vals)
  (define u(flatten (car li)))
  (define v generatedVals)
  (define g(remove* u generatedVals))
  (define n (cartesian-product (list(car li))g))
  n
  )

(define (cartManager evalList [vals '()])
  (define li generatedVals)
  (if (null? evalList)
      (println(filter evaluateRPN vals))
      (if (empty? vals)
      (cartManager (cdr (cdr evalList)) (cart li (car evalList))) 
      (cartManager (cdr evalList) (cart vals (car evalList))))))

(define (kdot li)
  (println li)
  (define g li)
  (println g))
(define (enqueueAndReturn stack value)
  (enqueue-front! stack value)
  stack)

(define (doRPN stack oper)
  (define a (dequeue! stack))
  (define b (dequeue! stack))
  (define c (oper b a))
  (enqueue-front! stack c)
  ;checking if the calculated value is negative or a fraction
  (if (and (exact-nonnegative-integer? c) (not(equal? c 0)))
      #t
      #f))

;(define perms(list(permutations (list 1 1 1 1 1 -1 -1))))
(define start-perm (list -1 -1 -1 1))

(define l(map cartManager (map make-rpn(remove-duplicates (permutations (list 1 1 1 1 -1 -1 -1 -1))))))
;(define kkk(filter evaluateRPN l))
;l
total
;(define qqqq(map evaluateRPN llll))
;qqqq