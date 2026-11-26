#lang racket
;; Jokers: weakest for tie-breaks, wildcard for the hand type.
(require "part1.rkt")
(provide solve)

(define (solve input) (winnings input #t))
