#lang racket
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
  (define results (cons (sum li)(cons (multiply li)(cons(subtract li)(cons (divide li)null)))))
  results)


(doMath (car (car perms)))
