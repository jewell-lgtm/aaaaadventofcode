;; Harness helpers.
;;   example: true when running an example (aoc test).
;;   (arg :size 71): example-specific constant from examples.toml `args`, else the default.
(ns aoc
  (:require [clojure.data.json :as json]))

(def example (= "1" (System/getenv "AOC_EXAMPLE")))

(def ^:private args (json/read-str (or (System/getenv "AOC_ARGS") "{}") :key-fn keyword))

(defn arg [k default] (get args (keyword k) default))
