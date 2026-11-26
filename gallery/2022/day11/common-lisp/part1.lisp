;;;; Monkey in the Middle: each block becomes a DEFSTRUCT (pulling integers out with
;;;; cl-ppcre, the operation as a closure), then rounds mutate the item lists in place.
;;;; RELIEF is (floor w 3) here; part 2 reduces modulo the product of divisors.
(defpackage :part1
  (:use :cl)
  (:export #:solve #:monkey-business #:monkey-divisor))
(in-package :part1)

(defstruct monkey items op divisor on-true on-false (inspected 0))

(defun ints (line) (mapcar #'parse-integer (ppcre:all-matches-as-strings "\\d+" line)))

(defun parse-op (line)
  (ppcre:register-groups-bind (op arg) ("new = old (.) (\\w+)" line)
    (cond ((string= arg "old") (lambda (x) (* x x)))
          ((string= op "*") (let ((n (parse-integer arg))) (lambda (x) (* x n))))
          (t (let ((n (parse-integer arg))) (lambda (x) (+ x n)))))))

(defun parse-monkey (block)
  (destructuring-bind (_ items op test on-true on-false) (aoc:lines block)
    (declare (ignore _))
    (make-monkey :items (ints items) :op (parse-op op) :divisor (first (ints test))
                 :on-true (first (ints on-true)) :on-false (first (ints on-false)))))

(defun monkey-business (input rounds relief)
  (let* ((monkeys (coerce (mapcar #'parse-monkey (ppcre:split "\\n\\n" input)) 'vector))
         (relieve (funcall relief (coerce monkeys 'list))))
    (dotimes (_ rounds)
      (loop for m across monkeys
            do (dolist (worry (monkey-items m))
                 (let* ((w (funcall relieve (funcall (monkey-op m) worry)))
                        (target (aref monkeys (if (zerop (mod w (monkey-divisor m)))
                                                  (monkey-on-true m)
                                                  (monkey-on-false m)))))
                   (setf (monkey-items target) (nconc (monkey-items target) (list w)))))
               (incf (monkey-inspected m) (length (monkey-items m)))
               (setf (monkey-items m) nil)))
    (let ((counts (sort (map 'list #'monkey-inspected monkeys) #'>)))
      (* (first counts) (second counts)))))

(defun solve (input) (monkey-business input 20 (lambda (monkeys) (declare (ignore monkeys)) (lambda (w) (floor w 3)))))
