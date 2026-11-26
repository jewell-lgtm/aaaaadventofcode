;; `sort-by` a key vector [type-rank card-strengths]; vectors compare element-wise.
;; A hand's type is its group-size shape, looked up in a map from shape to rank.
(ns part1
  (:require [clojure.string :as str]))

(defn parse [input]
  (for [line (str/split-lines (str/trim input))
        :let [[cards bid] (str/split line #" ")]]
    {:cards cards :bid (parse-long bid)}))

(defn shape
  "Group sizes, largest first: [3 2] is a full house, [1 1 1 1 1] high card."
  [cards]
  (->> cards frequencies vals (sort >) vec))

(def type-rank
  (zipmap [[1 1 1 1 1] [2 1 1 1] [2 2 1] [3 1 1] [3 2] [4 1] [5]] (range)))

(defn winnings [hands shape-of order]
  (->> hands
       (sort-by (fn [{:keys [cards]}]
                  [(type-rank (shape-of cards)) (mapv #(str/index-of order %) cards)]))
       (map-indexed (fn [i {:keys [bid]}] (* (inc i) bid)))
       (reduce +)))

(defn solve [input]
  (winnings (parse input) shape "23456789TJQKA"))
