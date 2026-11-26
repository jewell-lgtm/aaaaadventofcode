#lang racket
;; 40 steps: the pair hash stays tiny, so this is as fast as part 1.
(require "part1.rkt")
(provide solve)

(define (solve input) (spread input 40))
