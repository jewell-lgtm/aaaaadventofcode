;; Tile the cave 5x5 by wrapping its risk function: +1 per tile step, 9 wraps to 1.
(ns part2
  (:require [part1 :refer [parse lowest-risk]]))

(defn tiled [{:keys [rows cols risk]} times]
  {:rows (* rows times)
   :cols (* cols times)
   :risk (fn [[r c]]
           (-> (risk [(mod r rows) (mod c cols)])
               (+ (quot r rows) (quot c cols) -1)
               (mod 9)
               inc))})

(defn solve [input]
  (lowest-risk (tiled (parse input) 5)))
