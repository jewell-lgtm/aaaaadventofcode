;; No relief, 10,000 rounds: worry modulo the product of all divisors keeps every
;; divisibility test intact and stays a small long.
(ns part2
  (:require [part1 :refer [parse monkey-business]]))

(defn solve [input]
  (let [monkeys (parse input)
        modulus (transduce (map :divisor) * monkeys)]
    (monkey-business monkeys 10000 #(mod % modulus))))
