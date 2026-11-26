#lang racket
;; Chiton: Dijkstra with data/heap's binary heap of (dist row col) vectors and a mutable
;; hash of best distances. A cave is a struct holding its size and a risk function, so
;; part 2's 5x5 tiling is a new function rather than a bigger grid.
(require data/heap)
(provide solve (struct-out cave) parse lowest-risk)

(struct cave (rows cols risk))

(define (parse input)
  (define lines (list->vector (string-split input "\n")))
  (cave (vector-length lines)
        (string-length (vector-ref lines 0))
        (λ (r c) (- (char->integer (string-ref (vector-ref lines r) c)) (char->integer #\0)))))

(define (lowest-risk cv)
  (match-define (cave rows cols risk) cv)
  (define best (make-hash (list (cons '(0 0) 0))))
  (define queue (make-heap (λ (a b) (<= (vector-ref a 0) (vector-ref b 0)))))
  (heap-add! queue (vector 0 0 0))
  (let loop ()
    (match-define (vector d r c) (heap-min queue))
    (heap-remove-min! queue)
    (cond
      [(and (= r (sub1 rows)) (= c (sub1 cols))) d]
      [else
       (for ([n (in-list (list (list (sub1 r) c) (list (add1 r) c) (list r (sub1 c)) (list r (add1 c))))])
         (match-define (list nr nc) n)
         (when (and (< -1 nr rows) (< -1 nc cols))
           (define nd (+ d (risk nr nc)))
           (when (< nd (hash-ref best n +inf.0))
             (hash-set! best n nd)
             (heap-add! queue (vector nd nr nc)))))
       (loop)])))

(define (solve input) (lowest-risk (parse input)))
