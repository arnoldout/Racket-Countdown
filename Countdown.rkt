#lang racket
(require data/queue)
(define l(list 1 1 1 1 1 -1 -1))
(define perms(list(permutations (list 1 1 1 1 1 -1 -1))))

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



(define (practiseQueue expression [stack (make-queue)])
  (cond (null? expression)
      [(if (= (car expression) 1) true false)]
      [else(if (= (dequeue! stack) 1) #t #f)]))


(practiseQueue l)



(define (valid-rpn? expression [stack (make-queue)]) 
  (cond (null? expression)
      [(if (= (dequeue! stack) 1) #t #f)
       (cond (= (car expression) 1)
          [valid-rpn? (cdr expression) ((enqueue! stack 1))]
          [else (valid-rpn? (cdr expression) ((dequeue! stack)))]
          )]))

(valid-rpn? l)

