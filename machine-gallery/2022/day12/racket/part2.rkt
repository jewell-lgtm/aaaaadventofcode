#lang racket
;; Backwards from E with the step rule reversed, until any square of height 'a'.
(require "part1.rkt")
(provide solve)

(define (solve input)
  (define grid (parse input))
  (bfs grid (find-char grid #\E)
       (λ (from to) (<= from (add1 to)))
       (λ (p) (= (height grid p) (char->integer #\a)))))
