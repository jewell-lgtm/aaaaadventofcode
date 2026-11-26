;; Same backwards BFS; stop at the first square of height a.
(ns part2
  (:require [part1 :refer [parse height steps-from-end]]))

(defn solve [input]
  (let [hill (parse input)]
    (steps-from-end hill #(= (int \a) (height hill %)))))
