#lang racket
(define l(list 1 2))
(define perms(list(permutations (list 1 2))))
perms

(define (f oper id l)
  (if (null? l)
      id
      (oper (car l) (f oper id (cdr l)))))

(define (sum l) (f + 0 l))
(define (multiply l) (f * 1 l))
(define (subtract l) (f - 0 l))
(define (divide l) (f / 1 l))

(define (doMath li)
  (sum(li))
  (multiply (li))
  (subtract (li))
  (divide (li)))


(doMath (car (car perms)))
