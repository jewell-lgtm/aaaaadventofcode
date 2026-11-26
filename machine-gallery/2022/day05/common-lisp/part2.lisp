;;;; The CrateMover 9001 moves crates as a block, keeping their order.
(defpackage :part2
  (:use :cl)
  (:export #:solve))
(in-package :part2)

(defun solve (input) (part1:run input #'identity))
