#lang racket
;; The CrateMover 9001 moves crates as a block, keeping their order.
(require "part1.rkt")
(provide solve)

(define (solve input) (run input identity))
