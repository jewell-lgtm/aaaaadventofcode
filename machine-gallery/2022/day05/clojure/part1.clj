;; Stacks are a vector of lists (head = top); each move is a pure function of the
;; stacks, so the procedure is a `reduce`. The crane decides how the taken crates land.
(ns part1
  (:require [clojure.string :as str]))

(defn parse-stacks [drawing]
  (let [rows  (butlast (str/split-lines drawing))
        width (count (re-seq #"\d+" (last (str/split-lines drawing))))]
    (vec (for [i (range width)]
           (->> rows
                (keep #(get % (+ 1 (* 4 i))))
                (filter #(Character/isLetter ^char %))
                (apply list))))))

(defn parse-moves [procedure]
  (for [[_ n from to] (re-seq #"move (\d+) from (\d+) to (\d+)" procedure)]
    [(parse-long n) (dec (parse-long from)) (dec (parse-long to))]))

(defn operate
  "Run every move; `land` orders the taken crates as they end up on the target stack."
  [input land]
  (let [[drawing procedure] (str/split input #"\n\n" 2)
        move (fn [stacks [n from to]]
               (let [[taken rest] (split-at n (stacks from))]
                 (-> stacks
                     (assoc from rest)
                     (update to #(concat (land taken) %)))))]
    (->> (parse-moves procedure)
         (reduce move (parse-stacks drawing))
         (map first)
         (apply str))))

(defn solve [input]
  (operate input reverse)) ; one crate at a time: their order flips
