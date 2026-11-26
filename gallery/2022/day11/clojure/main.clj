;; Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
(ns main)

(defn -main [& _]
  (let [part  (if (= "2" (System/getenv "AOC_PART")) "part2" "part1")
        input (slurp *in*)]
    (println (str ((requiring-resolve (symbol part "solve")) input)))))
