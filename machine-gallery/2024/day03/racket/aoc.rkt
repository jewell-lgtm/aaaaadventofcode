#lang racket/base
;; Harness helpers.
;;   example?: #t when running an example (aoc test).
;;   (arg 'size 71): example-specific constant from examples.toml `args`, else the default.
(require json)
(provide example? arg)

(define example? (equal? (getenv "AOC_EXAMPLE") "1"))

(define args (string->jsexpr (or (getenv "AOC_ARGS") "{}")))
(define (arg name default) (hash-ref args name default))
