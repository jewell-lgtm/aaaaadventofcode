;; Monkeys parsed into maps with re-seq; the whole troop is one immutable value and a
;; round is a `reduce` over monkey indices. Runs the rounds with `iterate`.
(ns part1
  (:require [clojure.string :as str]))

(defn- numbers [s] (mapv parse-long (re-seq #"\d+" s)))

(defn parse-monkey [block]
  (let [[_ items op test yes no] (str/split-lines block)
        [_ sym operand]          (re-find #"old ([*+]) (\w+)" op)
        f                        (if (= sym "*") * +)
        n                        (parse-long operand)]
    {:items     (numbers items)
     :op        (fn [old] (f old (or n old)))
     :divisor   (first (numbers test))
     :targets   [(first (numbers yes)) (first (numbers no))]
     :inspected 0}))

(defn parse [input]
  (mapv parse-monkey (str/split (str/trim input) #"\n\n")))

(defn turn
  "Monkey i inspects and throws all its items; `relief` calms each worry level."
  [relief monkeys i]
  (let [{:keys [items op divisor targets]} (monkeys i)
        throw-item (fn [ms item]
                     (let [worry (relief (op item))
                           to    (targets (if (zero? (mod worry divisor)) 0 1))]
                       (update-in ms [to :items] conj worry)))]
    (-> (reduce throw-item monkeys items)
        (assoc-in [i :items] [])
        (update-in [i :inspected] + (count items)))))

(defn monkey-business [monkeys rounds relief]
  (let [round (fn [ms] (reduce (partial turn relief) ms (range (count ms))))]
    (->> (nth (iterate round monkeys) rounds)
         (map :inspected)
         (sort >)
         (take 2)
         (apply *))))

(defn solve [input]
  (monkey-business (parse input) 20 #(quot % 3)))
