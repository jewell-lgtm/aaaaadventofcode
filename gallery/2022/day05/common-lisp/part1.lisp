;;;; Supply Stacks: build a vector of lists by PUSHing crates bottom-up, so each list's
;;;; head is the top crate. Moves are parsed with register-groups-bind and applied in
;;;; place; CRANE decides whether lifted crates flip (9000) or keep order (9001).
(defpackage :part1
  (:use :cl)
  (:export #:solve #:run))
(in-package :part1)

(defun parse-stacks (drawing)
  (let* ((rows (reverse (split-sequence:split-sequence #\Newline drawing)))
         (stacks (make-array (floor (1+ (length (first rows))) 4) :initial-element nil)))
    (dolist (row (rest rows) stacks)
      (loop for i below (length stacks)
            for col = (1+ (* 4 i))
            when (and (< col (length row)) (char/= (char row col) #\Space))
              do (push (char row col) (aref stacks i))))))

(defun run (input crane)
  (destructuring-bind (drawing moves) (ppcre:split "\\n\\n" input)
    (let ((stacks (parse-stacks drawing)))
      (dolist (line (aoc:lines moves))
        (ppcre:register-groups-bind ((#'parse-integer n from to))
            ("move (\\d+) from (\\d+) to (\\d+)" line)
          (let ((lifted (subseq (aref stacks (1- from)) 0 n)))
            (setf (aref stacks (1- from)) (nthcdr n (aref stacks (1- from))))
            (setf (aref stacks (1- to)) (append (funcall crane lifted) (aref stacks (1- to)))))))
      (coerce (remove nil (map 'list #'first stacks)) 'string))))

(defun solve (input) (run input #'reverse))
