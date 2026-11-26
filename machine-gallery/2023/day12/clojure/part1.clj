;; Count arrangements by recursion on (springs, groups) as seqs, memoised with
;; `memoize` over a `defn` that recurs through its own var. `case` on the head char.
(ns part1
  (:require [clojure.string :as str]))

(declare arrangements)

(defn- place-group
  "Ways if a damaged group of size (first groups) starts here."
  [springs [n & more]]
  (let [[block after] (split-at (or n 0) springs)]
    (if (and n
             (= n (count block))
             (not-any? #{\.} block)
             (not= \# (first after)))
      (arrangements (rest after) more)
      0)))

(defn- arrangements* [springs groups]
  (if (empty? springs)
    (if (empty? groups) 1 0)
    (case (first springs)
      \. (arrangements (rest springs) groups)
      \# (place-group springs groups)
      \? (+ (arrangements (rest springs) groups)
            (place-group springs groups)))))

(def arrangements (memoize arrangements*))

(defn parse [input]
  (for [line (str/split-lines (str/trim input))
        :let [[springs groups] (str/split line #" ")]]
    [springs (map parse-long (str/split groups #","))]))

(defn solve [input]
  (transduce (map (fn [[s g]] (arrangements (seq s) g))) + (parse input)))
