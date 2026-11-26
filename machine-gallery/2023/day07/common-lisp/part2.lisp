;;;; Jokers: weakest for tie-breaks, wildcard for the hand type.
(defpackage :part2
  (:use :cl)
  (:export #:solve))
(in-package :part2)

(defun solve (input) (part1:winnings input t))
