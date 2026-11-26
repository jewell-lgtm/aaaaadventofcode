#lang racket
;; Monkey Math: each job is a number or a (op left right) list in a hash; `eval-job`
;; recurses with `match`. Racket's exact rationals mean "/" is always exact.
(provide solve parse eval-job)

(define (parse input)
  (for/hash ([line (string-split input "\n")])
    (match (string-split line)
      [(list name n) (values (string-trim name ":") (string->number n))]
      [(list name a op b) (values (string-trim name ":") (list (string->symbol op) a b))])))

(define ops (hash '+ + '- - '* * '/ /))

(define (eval-job jobs name)
  (match (hash-ref jobs name)
    [(? number? n) n]
    [(list op a b) ((hash-ref ops op) (eval-job jobs a) (eval-job jobs b))]))

(define (solve input) (eval-job (parse input) "root"))
