;;;; Hot Springs: recursive count over (spring index, groups placed), memoised in an
;;;; EQUAL hash table inside LABELS. Each '?' is tried as operational and as the start
;;;; of the next damaged group.
(defpackage :part1
  (:use :cl)
  (:export #:solve #:arrangements #:parse-line))
(in-package :part1)

(defun arrangements (springs groups)
  (let* ((n (length springs))
         (groups (coerce groups 'vector))
         (m (length groups))
         (memo (make-hash-table :test #'equal)))
    (labels ((fits (i len)
               ;; a run of LEN damaged springs at I: no '.', then not followed by '#'
               (and (<= (+ i len) n)
                    (not (find #\. springs :start i :end (+ i len)))
                    (or (= (+ i len) n) (char/= (char springs (+ i len)) #\#))))
             (operational (i j) (count-from (1+ i) j))
             (damaged (i j)
               (if (and (< j m) (fits i (aref groups j)))
                   (count-from (min n (+ i (aref groups j) 1)) (1+ j))
                   0))
             (count-from (i j)
               (alexandria:ensure-gethash
                (cons i j) memo
                (if (= i n)
                    (if (= j m) 1 0)
                    (ecase (char springs i)
                      (#\. (operational i j))
                      (#\# (damaged i j))
                      (#\? (+ (operational i j) (damaged i j))))))))
      (count-from 0 0))))

(defun parse-line (line)
  (destructuring-bind (springs groups) (split-sequence:split-sequence #\Space line)
    (values springs (mapcar #'parse-integer (split-sequence:split-sequence #\, groups)))))

(defun solve (input)
  (loop for line in (aoc:lines input)
        sum (multiple-value-call #'arrangements (parse-line line))))
