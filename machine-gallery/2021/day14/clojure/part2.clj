;; Forty steps: pair counts stay tiny, so the same code just runs longer.
(ns part2
  (:require [part1 :refer [parse spread]]))

(defn solve [input]
  (spread (parse input) 40))
