;; humn is the unknown. Walk from root down the side that depends on humn, inverting
;; each operation against the constant side's value (`case` on the op symbol).
(ns part2
  (:require [part1 :refer [parse evaluate]]))

(defn human? [jobs name]
  (or (= name "humn")
      (let [job (jobs name)]
        (and (vector? job) (some #(human? jobs %) (rest job))))))

(defn solve-for
  "The value humn must shout so that monkey `name` yields `target`."
  [jobs name target]
  (if (= name "humn")
    target
    (let [[op a b] (jobs name)]
      (if (human? jobs a)
        (let [v (evaluate jobs b)] ; target = x op v
          (recur jobs a (case op + (- target v), - (+ target v), * (quot target v), / (* target v))))
        (let [v (evaluate jobs a)] ; target = v op x
          (recur jobs b (case op + (- target v), - (- v target), * (quot target v), / (quot v target))))))))

(defn solve [input]
  (let [jobs (parse input)
        [_ a b] (jobs "root")]
    (if (human? jobs a)
      (solve-for jobs a (evaluate jobs b))
      (solve-for jobs b (evaluate jobs a)))))
