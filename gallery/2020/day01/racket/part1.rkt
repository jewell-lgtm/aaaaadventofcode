#lang racket
;; Report Repair: for/first over the lazy `in-combinations` sequence stops at the first
;; k entries summing to 2020. The same helper serves both parts (k = 2, then 3).
(provide solve parse product-of-sum)

(define (parse input) (map string->number (string-split input)))

(define (product-of-sum nums k target)
  (for/first ([combo (in-combinations nums k)]
              #:when (= target (apply + combo)))
    (apply * combo)))

(define (solve input) (product-of-sum (parse input) 2 2020))
