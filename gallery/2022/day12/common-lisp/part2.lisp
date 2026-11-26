;;;; Backwards from E with the step rule reversed, until any square of height 'a'.
(defpackage :part2
  (:use :cl)
  (:export #:solve))
(in-package :part2)

(defun solve (input)
  (let ((grid (part1:parse input)))
    (part1:bfs grid (part1:find-char grid #\E)
               (lambda (from to) (<= from (1+ to)))
               (lambda (p) (= (part1:height grid p) (char-code #\a))))))
