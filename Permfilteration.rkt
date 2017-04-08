#lang racket

(define (subsetsum l)
  (filter 170 (map (lambda (i) (apply * i))
       (combinations l))))

(define L (list 1 2 1 2 3 17 10 0 4 4 4 ))
(subsetsum L)

The text associated with this error code could not be found.\r\n\r\nA PhraseList that is referenced in a 'Feedback'
element must be referenced in all 'ListenFor' elements for the corresponding Command. Error was found at Line: 18 Position: 1"}