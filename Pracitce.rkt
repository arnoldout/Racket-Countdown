#lang racket
(define a (list 4))
(define b (list 2))
(define c (list 3))
(define d (list 5))
(define e (list 6))
(define f (list 7))
(define g (list 8))
(define h (list 4 2 3 5 6 7 8))
(define (cart expressions)
  (define exp(remove* a expressions))
  (cartesian-product a exp))

(cart h)