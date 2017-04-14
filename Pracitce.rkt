#lang racket

(define a (list 4))
(define b (list 2))
(define c (list 3))
(define d (list 5))
(define e (list 6))
(define f (list 7))
(define g (list 8))
(define h (list 1 2 3 4 5 6))
(define j (list 1 1 1 1 1 1 1 -1 -1 -1 -1 -1))
(define k (list + - * /))
(define (cart li evalType [vals '()])
  (if (null? li)
     vals
     (if(equal? evalType 1)
         (if (pair?(car li))
             (cart(cdr li) evalType (append (cartesian-product (list(flatten (car li)))(remove* (flatten (car li))h))vals))
             (cart(cdr li) evalType (append (cartesian-product (list (car li))(remove (car li) h))vals)))
         
         (cart(cdr li) evalType (append (cartesian-product (list(flatten (car li)))k)vals))
         )
         ))
(define (cartManager li evalList [vals '()])
  (println vals)
  (if (null? evalList)
      vals
      (if (empty? vals)
      (cartManager li (cdr evalList) (append(cart li (car evalList))vals))    
      (cartManager li (cdr evalList) (append(cart vals (car evalList))vals)))))

(cartManager h j)