;; Two entries summing to 2020: one pass with a set of the numbers seen so far.
;; Sets are functions in Clojure, so `(seen x)` is the membership test.
(ns part1
  (:require [clojure.string :as str]))

(def target 2020)

(defn parse [input]
  (map parse-long (str/split-lines (str/trim input))))

(defn pair-product
  "Product of some a, b in nums with a + b = total, or nil."
  [nums total]
  (loop [[a & more] nums
         seen #{}]
    (when a
      (if (seen (- total a))
        (* a (- total a))
        (recur more (conj seen a))))))

(defn solve [input]
  (pair-product (parse input) target))
