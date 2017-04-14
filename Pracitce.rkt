#lang racket

(define a (list 4))
(define b (list 2))
(define c (list 3))
(define d (list 5))
(define e (list 6))
(define f (list 7))
(define g (list 8))
(define h (list 1 2 3 4 5 6))
(define j (list 1 1 -1 -1 -1 -1 1 1 1 1 -1))
(define (cart li [vals '()])
  (if (null? li)
     vals
         (if (pair?(car li))
             (cart(cdr li)(append (cartesian-product (list(flatten (car li)))(remove* (flatten (car li))h))vals))
             (cart(cdr li)(append (cartesian-product (list (car li))(remove (car li) h))vals)))
         ))
(define bv(cart h))
bv
(cart bv)
(define cc(cart (cart (cart (cart bv)))))
cc