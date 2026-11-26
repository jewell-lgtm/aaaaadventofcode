;;;; Unfold each row five times (springs joined by "?"), then the same DP.
(defpackage :part2
  (:use :cl)
  (:export #:solve))
(in-package :part2)

(defun unfold (springs groups)
  (values (format nil "~{~a~^?~}" (make-list 5 :initial-element springs))
          (loop repeat 5 append groups)))

(defun solve (input)
  (loop for line in (aoc:lines input)
        sum (multiple-value-call #'part1:arrangements
              (multiple-value-call #'unfold (part1:parse-line line)))))
