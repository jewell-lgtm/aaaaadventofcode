#lang racket
;; No more relief: reduce worry modulo the product of all (prime) divisors, which
;; keeps every divisibility test intact (Racket would cope with bignums, but slowly).
(require "part1.rkt")
(provide solve)

(define (solve input)
  (monkey-business input 10000
                   (λ (monkeys)
                     (define m (apply * (map monkey-divisor monkeys)))
                     (λ (w) (modulo w m)))))
