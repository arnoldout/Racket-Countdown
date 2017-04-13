#lang racket
(require data/queue)
(define l(list 1 1 -1 1 1 1 1 -1 -1 -1 -1))
;(define perms(list(permutations (list 1 1 1 1 1 -1 -1))))

(define (f oper id l)
  (if (null? l)
      id
      (oper (car l) (f oper id (cdr l)))))

(define (fsum l) (f + 0 l))
(define (fmult l) (f * 0 l))
;(fmult (car (car perms)))
(define q (make-queue))

(define start-perm (list -1 -1 -1 -1 1 1 1 1))

(define perms (remove-duplicates (permutations start-perm)))

(define (make-rpn l)
  (append (list 1 1) l (list -1)))

(make-rpn (car  perms))

(define lll(map make-rpn perms))


(define (isValidRPN expression [stack 0])
  (if(< stack 0)
     #f
     (if (null? expression)
         ;end of recursion, check state of stack, if 1 then expressin is valid RPN
         (if (= stack 1)
             #t
             #f)
         ;expression still has values, update stack and recursively call self with updated stack and cdr of expression
         (cond [(equal? (car expression)1)(isValidRPN (cdr expression) (+ stack 1))]
               [(equal? (car expression)-1)(isValidRPN (cdr expression) (- stack 1))]
               [else (isValidRPN (cdr expression) (stack))]
               ))))
(define (convertToValues binaryList values operands [mappedVals '()] )
  (if(null? binaryList)
     mappedVals
     (if(equal?(car binaryList)1)
        (convertToValues  (cdr binaryList) values operands (cartesianOnList values mappedVals))
        (convertToValues  (cdr binaryList) values operands (cartesianOnList operands mappedVals))
        )
  ))
(define  (cartesianOnList list value)
  (define a (cartesian-product list value))
  (define b(list 2 3))
  a)
(define (evaluateRPN expression total [stack (make-queue)])
     (if (null? expression)
         (if (=(queue-length stack) 1)
             (if (equal?(dequeue! stack)total)
                 #t
                 #f)
         #f)
         (if (procedure? (car expression))
         (evaluateRPN (cdr expression) total (doRPN stack (car expression)))    
         (evaluateRPN (cdr expression) total (enqueueAndReturn stack (car expression)))
               )))

(define (enqueueAndReturn stack value)
  (enqueue-front! stack value)
  stack)
(define (doRPN stack oper)
  (define a (dequeue! stack))
  (define b (dequeue! stack))
  (define c (oper b a))
  (enqueue-front! stack c)
   stack)
(define qqq(filter isValidRPN lll))
qqq
(define ff (list 4 3 5 7 8 6))
(define g (list + - / *))
(define exp(list '(3 5 + 7 2 - *)(3 5 + 7 9 * *)(3 1 + 7 9 - +)))
;(convertToValues l ff g)
(define qqqq(filter evaluateRPN( exp 40)))
qqqq


