#lang racket
;; Unfold each row five times (springs joined by "?"), then the same DP.
(require "part1.rkt")
(provide solve)

(define (solve input)
  (for/sum ([line (string-split input "\n")])
    (define-values (springs groups) (parse-line line))
    (arrangements (string-join (make-list 5 springs) "?") (append* (make-list 5 groups)))))
