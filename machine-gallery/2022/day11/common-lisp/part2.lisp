;;;; No more relief: reduce worry modulo the product of all (prime) divisors, which
;;;; keeps every divisibility test intact (and keeps us out of bignum territory).
(defpackage :part2
  (:use :cl)
  (:export #:solve))
(in-package :part2)

(defun solve (input)
  (part1:monkey-business input 10000
                         (lambda (monkeys)
                           (let ((m (reduce #'* monkeys :key #'part1:monkey-divisor)))
                             (lambda (w) (mod w m))))))
