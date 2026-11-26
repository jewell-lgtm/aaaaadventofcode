;;;; Chiton: Dijkstra with a bucket queue (Dial's algorithm). Risks are 1-9, so a vector
;;;; of lists indexed by distance is a perfectly good priority queue; walk it upward.
;;;; The cave is a struct with a RISK function, so part 2 tiles it without a bigger grid.
(defpackage :part1
  (:use :cl)
  (:export #:solve #:parse #:lowest-risk #:cave #:make-cave #:cave-rows #:cave-cols #:cave-risk))
(in-package :part1)

(defstruct cave rows cols risk)

(defun parse (input)
  (let ((rows (coerce (aoc:lines input) 'vector)))
    (make-cave :rows (length rows) :cols (length (aref rows 0))
               :risk (lambda (r c) (digit-char-p (char (aref rows r) c))))))

(defun lowest-risk (cave)
  (let* ((rows (cave-rows cave)) (cols (cave-cols cave))
         (best (make-array (list rows cols) :initial-element nil))
         (buckets (make-array 1 :adjustable t :fill-pointer 1 :initial-element (list '(0 . 0)))))
    (setf (aref best 0 0) 0)
    (loop for d from 0
          do (dolist (pos (aref buckets d))
               (destructuring-bind (r . c) pos
                 (when (and (= r (1- rows)) (= c (1- cols)))
                   (return-from lowest-risk d))
                 (when (= d (aref best r c)) ; skip stale entries
                   (loop for (nr . nc) in (list (cons (1- r) c) (cons (1+ r) c) (cons r (1- c)) (cons r (1+ c)))
                         when (and (< -1 nr rows) (< -1 nc cols))
                           do (let ((nd (+ d (funcall (cave-risk cave) nr nc))))
                                (when (or (null (aref best nr nc)) (< nd (aref best nr nc)))
                                  (setf (aref best nr nc) nd)
                                  (loop while (<= (fill-pointer buckets) nd)
                                        do (vector-push-extend nil buckets))
                                  (push (cons nr nc) (aref buckets nd)))))))))))

(defun solve (input) (lowest-risk (parse input)))
