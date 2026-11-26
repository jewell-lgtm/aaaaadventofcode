#lang racket
;; Hot Springs: count arrangements recursively over (spring index, groups placed),
;; memoised with `hash-ref!` on a mutable hash. Each '?' is tried as operational and as
;; the start of the next damaged group.
(provide solve arrangements parse-line)

(define (arrangements springs groups)
  (define n (string-length springs))
  (define gs (list->vector groups))
  (define m (vector-length gs))
  ;; can a run of `len` damaged springs start at i? no '.', and not followed by '#'
  (define (fits? i len)
    (and (<= (+ i len) n)
         (for/and ([k (in-range i (+ i len))]) (not (char=? (string-ref springs k) #\.)))
         (or (= (+ i len) n) (not (char=? (string-ref springs (+ i len)) #\#)))))
  (define memo (make-hash))
  (define (count i j)
    (hash-ref! memo (cons i j)
               (λ ()
                 (define (operational) (count (add1 i) j))
                 (define (damaged)
                   (if (and (< j m) (fits? i (vector-ref gs j)))
                       (count (min n (+ i (vector-ref gs j) 1)) (add1 j))
                       0))
                 (if (= i n)
                     (if (= j m) 1 0)
                     (match (string-ref springs i)
                       [#\. (operational)]
                       [#\# (damaged)]
                       [#\? (+ (operational) (damaged))])))))
  (count 0 0))

(define (parse-line line)
  (match-define (list springs groups) (string-split line))
  (values springs (map string->number (string-split groups ","))))

(define (solve input)
  (for/sum ([line (string-split input "\n")])
    (call-with-values (λ () (parse-line line)) arrangements)))
