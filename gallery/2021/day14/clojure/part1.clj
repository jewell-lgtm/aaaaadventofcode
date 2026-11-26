;; Count pairs, not the polymer: each rule AB -> C turns AB into AC and CB.
;; `frequencies` of `partition 2 1` seeds the counts; `merge-with +` combines them.
(ns part1
  (:require [clojure.string :as str]))

(defn parse [input]
  (let [[template rules] (str/split (str/trim input) #"\n\n")]
    {:template (str/trim template)
     :rules    (into {} (for [[_ a b c] (re-seq #"(\w)(\w) -> (\w)" rules)]
                          [[(first a) (first b)] (first c)]))}))

(defn step [rules pairs]
  (apply merge-with +
         (for [[[a b :as pair] n] pairs]
           (if-let [c (rules pair)]
             {[a c] n, [c b] n}
             {pair n}))))

(defn spread
  "Most common element count minus least common after `steps` insertions."
  [{:keys [template rules]} steps]
  (let [pairs  (nth (iterate (partial step rules) (frequencies (partition 2 1 template))) steps)
        ;; Every element but the template's last starts exactly one pair.
        counts (apply merge-with + {(last template) 1}
                      (for [[[a _] n] pairs] {a n}))]
    (- (apply max (vals counts)) (apply min (vals counts)))))

(defn solve [input]
  (spread (parse input) 10))
