;;;; Camel Cards: SORT with a hand-written HAND< predicate: compare hand types, then
;;;; card strengths left to right. The type comes from the sorted group sizes;
;;;; with jokers, J is the weakest card and joins the biggest group.
(defpackage :part1
  (:use :cl)
  (:export #:solve #:winnings))
(in-package :part1)

(defun hand-type (hand jokers)
  (let* ((j (if jokers (count #\J hand) 0))
         (rest (if jokers (remove #\J hand) hand))
         (groups (sort (map 'list (lambda (c) (count c rest)) (remove-duplicates rest)) #'>)))
    (if groups (incf (first groups) j) (setf groups (list j)))
    (cond ((equal groups '(5)) 6)
          ((equal groups '(4 1)) 5)
          ((equal groups '(3 2)) 4)
          ((equal groups '(3 1 1)) 3)
          ((equal groups '(2 2 1)) 2)
          ((equal groups '(2 1 1 1)) 1)
          (t 0))))

(defun hand< (a b jokers)
  (let ((order (if jokers "J23456789TQKA" "23456789TJQKA"))
        (ta (hand-type a jokers))
        (tb (hand-type b jokers)))
    (if (/= ta tb)
        (< ta tb)
        (loop for x across a
              for y across b
              unless (char= x y) return (< (position x order) (position y order))))))

(defun winnings (input jokers)
  (let ((hands (loop for line in (aoc:lines input)
                     collect (destructuring-bind (hand bid) (split-sequence:split-sequence #\Space line)
                               (cons hand (parse-integer bid))))))
    (loop for (nil . bid) in (sort hands (lambda (a b) (hand< a b jokers)) :key #'car)
          for rank from 1
          sum (* rank bid))))

(defun solve (input) (winnings input nil))
