;;;; 40 steps: the pair table stays tiny, so this is as fast as part 1.
(defpackage :part2
  (:use :cl)
  (:export #:solve))
(in-package :part2)

(defun solve (input) (part1:spread input 40))
