;; CrateMover 9001 moves the block as is.
(ns part2
  (:require [part1 :refer [operate]]))

(defn solve [input]
  (operate input identity))
