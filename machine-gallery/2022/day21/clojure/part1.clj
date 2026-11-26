;; Jobs as data: a number or [op left right] with op a symbol. Evaluation looks the
;; operator up in a map to the real function and recurses.
(ns part1
  (:require [clojure.string :as str]))

(def ops {'+ + '- - '* * '/ quot})

(defn parse [input]
  (into {}
        (for [line (str/split-lines (str/trim input))
              :let [[name job] (str/split line #": ")
                    [a op b]   (str/split job #" ")]]
          [name (if op [(symbol op) a b] (parse-long a))])))

(defn evaluate [jobs name]
  (let [job (jobs name)]
    (if (number? job)
      job
      (let [[op a b] job]
        ((ops op) (evaluate jobs a) (evaluate jobs b))))))

(defn solve [input]
  (evaluate (parse input) "root"))
