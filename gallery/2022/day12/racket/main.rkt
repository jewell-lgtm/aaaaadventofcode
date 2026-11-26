#lang racket/base
;; Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
(require racket/port (prefix-in p1: "part1.rkt") (prefix-in p2: "part2.rkt"))

(define solve (if (equal? (getenv "AOC_PART") "2") p2:solve p1:solve))
(displayln (solve (port->string (current-input-port))))
