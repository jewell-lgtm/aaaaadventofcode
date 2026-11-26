#lang racket
;; One regex for all three instructions; for/fold carries (enabled? sum) and `match`
;; dispatches on the shape of each match.
(provide solve)

(define instruction #px"mul\\((\\d{1,3}),(\\d{1,3})\\)|do\\(\\)|don't\\(\\)")

(define (solve input)
  (for/fold ([on? #t] [sum 0] #:result sum)
            ([m (regexp-match* instruction input #:match-select values)])
    (match m
      [(list "do()" _ _) (values #t sum)]
      [(list "don't()" _ _) (values #f sum)]
      [(list _ a b) (values on? (if on? (+ sum (* (string->number a) (string->number b))) sum))])))
