;; BFS backwards from E with a persistent queue and a distance map in `loop`/`recur`.
;; The grid is a vector of strings; `get-in` returns nil off the edge.
(ns part1
  (:require [clojure.string :as str]))

(defn parse [input]
  (let [grid (vec (str/split-lines (str/trim input)))
        find (fn [ch] (first (for [r (range (count grid)) c (range (count (grid r)))
                                  :when (= ch (get-in grid [r c]))] [r c])))]
    {:grid grid :start (find \S) :end (find \E)}))

(defn height [{:keys [grid]} pos]
  (case (get-in grid pos)
    nil nil
    \S (int \a)
    \E (int \z)
    (int (get-in grid pos))))

(defn steps-from-end
  "Fewest steps from any position satisfying `goal?` up to E."
  [hill goal?]
  (loop [queue (conj clojure.lang.PersistentQueue/EMPTY (:end hill))
         dist  {(:end hill) 0}]
    (when-let [[r c :as cur] (peek queue)]
      (if (goal? cur)
        (dist cur)
        (let [h    (height hill cur)
              next (for [n [[(inc r) c] [(dec r) c] [r (inc c)] [r (dec c)]]
                         :let [nh (height hill n)]
                         :when (and nh (not (dist n)) (<= (- h nh) 1))]
                     n)]
          (recur (into (pop queue) next)
                 (into dist (map #(vector % (inc (dist cur)))) next)))))))

(defn solve [input]
  (let [hill (parse input)]
    (steps-from-end hill #(= % (:start hill)))))
