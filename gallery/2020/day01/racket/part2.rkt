#lang racket
;; Three entries instead of two: same search, k = 3.
(require "part1.rkt")
(provide solve)

(define (solve input) (product-of-sum (parse input) 3 2020))
