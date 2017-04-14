#lang racket

(define a (list 4))
(define b (list 2))
(define c (list 3))
(define d (list 5))
(define e (list 6))
(define f (list 7))
(define g (list 8))
(define h (list 1 2 3 4 5 6))
(define (cart li [vals '()])
  (if (null? li)
     vals
     (if (pair?(car li))
         (cart(cdr li)(append (func (car li))vals))
         (cart(cdr li)(append (func2 (car li))vals)))))


(define (func li)
  (define nn(list (flatten li)))
  (define nnm(remove* (flatten li)h))
  (define nnmn(cartesian-product nn nnm))
  (println nnmn)
  nnmn)
(define (func2 li)
  (define dd(remove li h))
  (cartesian-product (list li)dd))
(define bv(cart a))
bv
(cart bv)
(define cc(cart (cart (cart (cart bv)))))
cc