;; Three entries: for each number, look for a pair summing to the remainder among the rest.
(ns part2
  (:require [part1 :refer [parse pair-product target]]))

(defn solve [input]
  (let [nums (vec (parse input))]
    (some (fn [i]
            (let [a (nums i)]
              (some->> (pair-product (subvec nums (inc i)) (- target a))
                       (* a))))
          (range (count nums)))))
