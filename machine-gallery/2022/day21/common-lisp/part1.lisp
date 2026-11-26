;;;; Monkey Math: a hash table maps each name to a number or an (op left right) list,
;;;; with the op already resolved to a function symbol; EVAL-MONKEY recurses with ETYPECASE.
(defpackage :part1
  (:use :cl)
  (:export #:solve #:parse #:eval-monkey))
(in-package :part1)

(defun parse (input)
  (let ((jobs (make-hash-table :test #'equal)))
    (dolist (line (aoc:lines input) jobs)
      (destructuring-bind (name . job) (split-sequence:split-sequence #\Space (remove #\: line))
        (setf (gethash name jobs)
              (if (rest job)
                  (destructuring-bind (a op b) job
                    (list (alexandria:eswitch (op :test #'string=) ("+" '+) ("-" '-) ("*" '*) ("/" '/)) a b))
                  (parse-integer (first job))))))))

(defun eval-monkey (jobs name)
  (let ((job (gethash name jobs)))
    (etypecase job
      (integer job)
      (list (destructuring-bind (op a b) job
              (funcall op (eval-monkey jobs a) (eval-monkey jobs b)))))))

(defun solve (input) (eval-monkey (parse input) "root"))
