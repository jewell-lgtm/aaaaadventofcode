;;;; One regex for all three instructions; a plain `enabled` flag is flipped by
;;;; do()/don't() while scanning, dispatched with alexandria:switch.
(defpackage :part2
  (:use :cl)
  (:export #:solve))
(in-package :part2)

(defun solve (input)
  (let ((enabled t) (sum 0))
    (ppcre:do-register-groups (instr a b)
        ("(do\\(\\)|don't\\(\\)|mul\\((\\d{1,3}),(\\d{1,3})\\))" input)
      (alexandria:switch (instr :test #'string=)
        ("do()" (setf enabled t))
        ("don't()" (setf enabled nil))
        (t (when enabled (incf sum (* (parse-integer a) (parse-integer b)))))))
    sum))
