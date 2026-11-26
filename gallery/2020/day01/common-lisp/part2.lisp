;;;; Fix x, reuse part 1's pair search on the entries after it for 2020 - x.
(defpackage :part2
  (:use :cl)
  (:export #:solve))
(in-package :part2)

(defun solve (input)
  (loop for (x . rest) on (part1:parse input)
        for p = (part1:pair-product rest (- 2020 x))
        when p return (* x p)))
