;;;; Hill Climbing: level-by-level BFS over a 2D character array, with a hash table of
;;;; visited squares. CAN-STEP and GOAL are functions, so part 2 runs the same search
;;;; backwards from E.
(defpackage :part1
  (:use :cl)
  (:export #:solve #:parse #:height #:find-char #:bfs))
(in-package :part1)

(defun parse (input)
  (let ((rows (aoc:lines input)))
    (make-array (list (length rows) (length (first rows))) :initial-contents rows)))

(defun height (grid pos)
  (case (aref grid (car pos) (cdr pos))
    (#\S (char-code #\a))
    (#\E (char-code #\z))
    (t (char-code (aref grid (car pos) (cdr pos))))))

(defun find-char (grid ch)
  (destructuring-bind (h w) (array-dimensions grid)
    (loop for r below h
          do (loop for c below w
                   when (char= (aref grid r c) ch) do (return-from find-char (cons r c))))))

(defun neighbours (grid pos)
  (destructuring-bind (h w) (array-dimensions grid)
    (loop for (dr . dc) in '((-1 . 0) (1 . 0) (0 . -1) (0 . 1))
          for r = (+ (car pos) dr)
          for c = (+ (cdr pos) dc)
          when (and (< -1 r h) (< -1 c w)) collect (cons r c))))

(defun bfs (grid start can-step goal)
  (let ((seen (make-hash-table :test #'equal)))
    (setf (gethash start seen) t)
    (flet ((expand (frontier)
             (loop for p in frontier
                   nconc (loop for q in (neighbours grid p)
                               when (and (not (gethash q seen))
                                         (funcall can-step (height grid p) (height grid q)))
                                 do (setf (gethash q seen) t)
                                 and collect q))))
      (do ((frontier (list start) (expand frontier))
           (steps 0 (1+ steps)))
          ((null frontier) nil)
        (when (some goal frontier) (return steps))))))

(defun solve (input)
  (let* ((grid (parse input))
         (end (find-char grid #\E)))
    (bfs grid (find-char grid #\S)
         (lambda (from to) (<= to (1+ from)))
         (lambda (p) (equal p end)))))
