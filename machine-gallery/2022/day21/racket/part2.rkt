#lang racket
;; Treat humn as x and evaluate every monkey to a linear form a*x + b, with exact
;; rationals for a and b. Root says left = right, which solves to one division.
(require "part1.rkt")
(provide solve)

(struct lin (a b)) ; a*x + b

(define (combine op l r)
  (match* (op l r)
    [('+ (lin a1 b1) (lin a2 b2)) (lin (+ a1 a2) (+ b1 b2))]
    [('- (lin a1 b1) (lin a2 b2)) (lin (- a1 a2) (- b1 b2))]
    [('* (lin a1 b1) (lin 0 k)) (lin (* a1 k) (* b1 k))]
    [('* (lin 0 k) (lin a2 b2)) (lin (* a2 k) (* b2 k))]
    [('/ (lin a1 b1) (lin 0 k)) (lin (/ a1 k) (/ b1 k))]))

(define (linear jobs name)
  (match* (name (hash-ref jobs name))
    [("humn" _) (lin 1 0)]
    [(_ (? number? n)) (lin 0 n)]
    [(_ (list op a b)) (combine op (linear jobs a) (linear jobs b))]))

(define (solve input)
  (define jobs (parse input))
  (match-define (list _ left right) (hash-ref jobs "root"))
  (match-define (lin a1 b1) (linear jobs left))
  (match-define (lin a2 b2) (linear jobs right))
  (/ (- b2 b1) (- a1 a2)))
