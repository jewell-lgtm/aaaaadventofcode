;;;; Mull It Over: cl-ppcre's do-register-groups binds (and parses) the capture groups
;;;; of every match in turn.
(defpackage :part1
  (:use :cl)
  (:export #:solve))
(in-package :part1)

(defun solve (input)
  (let ((sum 0))
    (ppcre:do-register-groups ((#'parse-integer a) (#'parse-integer b))
        ("mul\\((\\d{1,3}),(\\d{1,3})\\)" input)
      (incf sum (* a b)))
    sum))
