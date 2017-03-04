#lang racket
(define l(list 1 2))
(define perms(list(permutations (list 1 2))))

(define (f oper id l)
  (if (null? l)
      id
      (oper (car l) (f oper id (cdr l)))))

(define (sum l) (f + 0 l))
(define (multiply l) (f * 1 l))
(define (subtract l) (f - 0 l))
(define (divide l) (f / 1 l))

(define (doMath li)
  (define results (list 1))
  (append results (sum li))
  (append results(multiply li))
  (append results(subtract li))
  (append results(divide li))
results)
(doMath (car (car perms)))
