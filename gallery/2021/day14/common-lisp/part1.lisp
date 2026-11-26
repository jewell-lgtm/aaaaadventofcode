;;;; Extended Polymerization: never build the polymer. Count adjacent pairs in an EQUAL
;;;; hash table; each step, pair "AB" with rule C becomes "AC" and "CB".
;;;; Element counts = first letter of every pair, plus the template's last letter.
(defpackage :part1
  (:use :cl)
  (:export #:solve #:spread))
(in-package :part1)

(defun spread (input steps)
  (destructuring-bind (template . rule-lines) (aoc:lines input)
    (let ((rules (make-hash-table :test #'equal))
          (pairs (make-hash-table :test #'equal))
          (counts (make-hash-table)))
      (dolist (line rule-lines)
        (setf (gethash (subseq line 0 2) rules) (char line 6)))
      (loop for i below (1- (length template))
            do (incf (gethash (subseq template i (+ i 2)) pairs 0)))
      (dotimes (_ steps)
        (let ((next (make-hash-table :test #'equal)))
          (maphash (lambda (pair n)
                     (alexandria:if-let (c (gethash pair rules))
                       (progn (incf (gethash (coerce (list (char pair 0) c) 'string) next 0) n)
                              (incf (gethash (coerce (list c (char pair 1)) 'string) next 0) n))
                       (incf (gethash pair next 0) n)))
                   pairs)
          (setf pairs next)))
      (incf (gethash (char template (1- (length template))) counts 0))
      (maphash (lambda (pair n) (incf (gethash (char pair 0) counts 0) n)) pairs)
      (let ((values (alexandria:hash-table-values counts)))
        (- (reduce #'max values) (reduce #'min values))))))

(defun solve (input) (spread input 10))
