;;;; Report Repair: LOOP's destructuring `for (x . rest) on nums` walks each entry
;;;; together with the entries after it; return at the first complement found.
(defpackage :part1
  (:use :cl)
  (:export #:solve #:parse #:pair-product))
(in-package :part1)

(defun parse (input) (mapcar #'parse-integer (aoc:lines input)))

(defun pair-product (nums target)
  (loop for (x . rest) on nums
        when (member (- target x) rest)
          return (* x (- target x))))

(defun solve (input) (pair-product (parse input) 2020))
