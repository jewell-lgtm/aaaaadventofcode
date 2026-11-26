;; Dijkstra with a sorted set of [dist pos] as the priority queue: `first` is the
;; minimum and `disj` pops it. The cave is a risk function so part 2 can tile it.
(ns part1
  (:require [clojure.string :as str]))

(defn parse [input]
  (let [grid (mapv #(mapv (comp parse-long str) %) (str/split-lines (str/trim input)))]
    {:rows (count grid) :cols (count (first grid)) :risk #(get-in grid %)}))

(defn neighbours [{:keys [rows cols]} [r c]]
  (for [[nr nc :as n] [[(inc r) c] [(dec r) c] [r (inc c)] [r (dec c)]]
        :when (and (< -1 nr rows) (< -1 nc cols))]
    n))

(defn lowest-risk [{:keys [rows cols risk] :as cave}]
  (let [goal [(dec rows) (dec cols)]]
    (loop [queue (sorted-set [0 [0 0]])
           best  {[0 0] 0}]
      (let [[d pos :as entry] (first queue)
            queue (disj queue entry)]
        (cond
          (= pos goal) d
          (> d (best pos)) (recur queue best)
          :else
          (let [better (for [n (neighbours cave pos)
                             :let [nd (+ d (risk n))]
                             :when (< nd (best n Long/MAX_VALUE))]
                         [nd n])]
            (recur (into queue better)
                   (into best (map (fn [[nd n]] [n nd])) better))))))))

(defn solve [input]
  (lowest-risk (parse input)))
