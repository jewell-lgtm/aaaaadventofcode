;; Jokers join the largest real group; J sorts weakest.
(ns part2
  (:require [part1 :refer [parse shape winnings]]))

(defn joker-shape [cards]
  (let [jokers         (count (filter #{\J} cards))
        [top & others] (shape (remove #{\J} cards))]
    (into [(+ (or top 0) jokers)] others)))

(defn solve [input]
  (winnings (parse input) joker-shape "J23456789TQKA"))
