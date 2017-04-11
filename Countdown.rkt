#lang racket
(require data/queue)
(define l(list 1 1 -1 1 1 1 1 -1 -1 -1 -1))
;(define perms(list(permutations (list 1 1 1 1 1 -1 -1))))

(define (f oper id l)
  (if (null? l)
      id
      (oper (car l) (f oper id (cdr l)))))

(define (fsum l) (f + 0 l))
(define (fmult l) (f * 0 l))
;(fmult (car (car perms)))
(define q (make-queue))

(define start-perm (list -1 -1 -1 -1 1 1 1 1))

(define perms (remove-duplicates (permutations start-perm)))

(define (make-rpn l)
  (append (list 1 1) l (list -1)))

(make-rpn (car  perms))

(define lll(map make-rpn perms))


(define (isValidRPN expression [stack 0])
  (if(< stack 0)
     #f
     (if (null? expression)
         ;end of recursion, check state of stack, if 1 then expression is valid RPN
         (if (= stack 1)
             #t
             #f)
         ;expression still has values, update stack and recursively call self with updated stack and cdr of expression
         (cond [(equal? (car expression)1)(isValidRPN (cdr expression) (+ stack 1))]
               [(equal? (car expression)-1)(isValidRPN (cdr expression) (- stack 1))]
               [else (isValidRPN (cdr expression) (stack))]
               ))))
  
(define qqq(filter isValidRPN lll))
qqq
