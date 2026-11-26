;;;; Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
;;;; Libraries preloaded in the image core: cl-ppcre, alexandria, split-sequence.
(dolist (file '("aoc" "part1" "part2"))
  (load (merge-pathnames (concatenate 'string file ".lisp") *load-truename*)))

(let* ((input (with-output-to-string (out)
                (loop for line = (read-line *standard-input* nil)
                      while line do (write-line line out))))
       (solver (if (equal (sb-ext:posix-getenv "AOC_PART") "2") #'part2:solve #'part1:solve)))
  (format t "~a~%" (funcall solver input)))
