;; One alternation regex yields tokens in order; `reduce` carries {:on? :sum}
;; and `case` dispatches on the token text.
(ns part2)

(def token-re #"mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)")

(defn step [{:keys [on?] :as state} [token a b]]
  (case token
    "do()"    (assoc state :on? true)
    "don't()" (assoc state :on? false)
    (cond-> state on? (update :sum + (* (parse-long a) (parse-long b))))))

(defn solve [input]
  (:sum (reduce step {:on? true :sum 0} (re-seq token-re input))))
