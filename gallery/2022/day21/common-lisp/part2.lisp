;;;; "humn" is the unknown. Walk down from root along the side that depends on humn,
;;;; inverting each operation against the other side's constant value.
(defpackage :part2
  (:use :cl)
  (:export #:solve))
(in-package :part2)

(defun humn-p (jobs name)
  (or (string= name "humn")
      (let ((job (gethash name jobs)))
        (and (listp job) (or (humn-p jobs (second job)) (humn-p jobs (third job)))))))

(defun solve-for (jobs name target)
  "The value humn must take for NAME to evaluate to TARGET."
  (if (string= name "humn")
      target
      (destructuring-bind (op a b) (gethash name jobs)
        (if (humn-p jobs a)
            (let ((v (part1:eval-monkey jobs b))) ; target = x op v
              (solve-for jobs a (ecase op (+ (- target v)) (- (+ target v)) (* (/ target v)) (/ (* target v)))))
            (let ((v (part1:eval-monkey jobs a))) ; target = v op x
              (solve-for jobs b (ecase op (+ (- target v)) (- (- v target)) (* (/ target v)) (/ (/ v target)))))))))

(defun solve (input)
  (let ((jobs (part1:parse input)))
    (destructuring-bind (op a b) (gethash "root" jobs)
      (declare (ignore op))
      (if (humn-p jobs a)
          (solve-for jobs a (part1:eval-monkey jobs b))
          (solve-for jobs b (part1:eval-monkey jobs a))))))
