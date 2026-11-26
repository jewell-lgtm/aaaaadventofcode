#lang racket
;; Mull It Over: regexp-match* with #:match-select values yields the capture groups of
;; every match; a for/sum multiplies them.
(provide solve)

(define (solve input)
  (for/sum ([m (regexp-match* #px"mul\\((\\d{1,3}),(\\d{1,3})\\)" input #:match-select cdr)])
    (apply * (map string->number m))))
