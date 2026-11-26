;; Unfold each row five times; the memo table does the heavy lifting.
(ns part2
  (:require [clojure.string :as str]
            [part1 :refer [parse arrangements]]))

(defn unfold [[springs groups]]
  [(str/join "?" (repeat 5 springs)) (apply concat (repeat 5 groups))])

(defn solve [input]
  (transduce (map (comp (fn [[s g]] (arrangements (seq s) g)) unfold)) + (parse input)))
