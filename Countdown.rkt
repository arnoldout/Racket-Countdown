#lang racket
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
(enqueue q "hi")
(dequeue q)