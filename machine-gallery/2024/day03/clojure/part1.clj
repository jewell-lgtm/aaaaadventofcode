;; `re-seq` returns every match as [whole a b]; destructure, multiply, sum.
(ns part1)

(def mul-re #"mul\((\d{1,3}),(\d{1,3})\)")

(defn solve [input]
  (transduce (map (fn [[_ a b]] (* (parse-long a) (parse-long b))))
             + (re-seq mul-re input)))
