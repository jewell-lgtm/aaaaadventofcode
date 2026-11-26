;;;; Tile the cave 5x5: every tile step adds 1 to the risk, wrapping 9 back to 1.
(defpackage :part2
  (:use :cl)
  (:import-from :part1 #:make-cave #:cave-rows #:cave-cols #:cave-risk)
  (:export #:solve))
(in-package :part2)

(defun tile (cave)
  (let ((h (cave-rows cave)) (w (cave-cols cave)) (risk (cave-risk cave)))
    (make-cave :rows (* 5 h) :cols (* 5 w)
               :risk (lambda (r c)
                       (1+ (mod (+ (funcall risk (mod r h) (mod c w)) (floor r h) (floor c w) -1) 9))))))

(defun solve (input) (part1:lowest-risk (tile (part1:parse input))))
