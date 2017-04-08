#lang racket
(require data/queue)
(define l(list 1 2))
(define perms(list(permutations (list 1 2))))
perms

(define (f oper id l)
  (if (null? l)
      id
      (oper (car l) (f oper id (cdr l)))))

(define (fsum l) (f + 0 l))
(define (fmult l) (f * 0 l))
(fmult (car (car perms)))
(define q (make-queue))
(enqueue! q "hi")
(dequeue! q)

(define (valid-rpn? expression [stack (make-queue)]) ;[arg 0] optional argument defaults to 0 if not passed
  (cond (null? expression)
      [(if (= stack 0) #t #f)
       (cond (= (car expression) 1)
          [valid-rpn? (cdr expression) ((enqueue! stack 1))]
          [else (valid-rpn? (cdr expression) ((dequeue! stack -1)))]
           ;decrement s by one
          )]))

(valid-rpn? l)

