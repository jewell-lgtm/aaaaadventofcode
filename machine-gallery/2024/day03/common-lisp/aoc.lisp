;;;; Harness helpers.
;;;;   (aoc:example-p): T when running an example (aoc test).
;;;;   (aoc:arg "size" 71): example-specific constant from examples.toml `args`, else the default.
;;;;   (aoc:lines input): non-empty lines.
(defpackage :aoc
  (:use :cl)
  (:export #:example-p #:arg #:lines))
(in-package :aoc)

(defun example-p () (equal (sb-ext:posix-getenv "AOC_EXAMPLE") "1"))

(defun lines (input) (split-sequence:split-sequence #\Newline input :remove-empty-subseqs t))

;; Flat JSON object {"k": 1, "s": "x", "b": true}: enough for AOC_ARGS.
(defun arg (name default)
  (let ((json (or (sb-ext:posix-getenv "AOC_ARGS") "{}")))
    (cl-ppcre:do-register-groups (key str raw) ("\"([^\"]*)\"\\s*:\\s*(?:\"([^\"]*)\"|([^,}]*))" json default)
      (when (string= key name)
        (return-from arg
          (cond (str str)
                ((string= (string-trim " " raw) "true") t)
                ((string= (string-trim " " raw) "false") nil)
                (t (read-from-string raw))))))))
