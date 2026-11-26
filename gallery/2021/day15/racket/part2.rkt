#lang racket
;; Tile the cave 5x5: every tile step adds 1 to the risk, wrapping 9 back to 1.
(require "part1.rkt")
(provide solve)

(define (tile cv)
  (match-define (cave h w risk) cv)
  (cave (* 5 h) (* 5 w)
        (λ (r c) (add1 (modulo (+ (risk (modulo r h) (modulo c w)) (quotient r h) (quotient c w) -1) 9)))))

(define (solve input) (lowest-risk (tile (parse input))))
