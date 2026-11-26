#lang racket
;; Hill Climbing: level-by-level BFS over immutable sets; for*/set builds each new
;; frontier with the step rule as a #:when clause. `can-step?` and `goal?` are
;; arguments, so part 2 runs the same search backwards from E.
(provide solve parse height find-char bfs)

;; grid: hash of (cons row col) -> char
(define (parse input)
  (for*/hash ([(line r) (in-indexed (string-split input "\n"))]
              [(ch c) (in-indexed line)])
    (values (cons r c) ch)))

(define (height grid pos)
  (match (hash-ref grid pos)
    [#\S (char->integer #\a)]
    [#\E (char->integer #\z)]
    [ch (char->integer ch)]))

(define (find-char grid ch)
  (for/first ([(pos x) (in-hash grid)] #:when (char=? x ch)) pos))

(define (neighbours pos)
  (match-define (cons r c) pos)
  (list (cons (sub1 r) c) (cons (add1 r) c) (cons r (sub1 c)) (cons r (add1 c))))

(define (bfs grid start can-step? goal?)
  (let loop ([frontier (set start)] [seen (set start)] [steps 0])
    (cond
      [(set-empty? frontier) #f]
      [(for/or ([p (in-set frontier)]) (goal? p)) steps]
      [else
       (define next
         (for*/set ([p (in-set frontier)]
                    [q (in-list (neighbours p))]
                    #:when (hash-has-key? grid q)
                    #:unless (set-member? seen q)
                    #:when (can-step? (height grid p) (height grid q)))
           q))
       (loop next (set-union seen next) (add1 steps))])))

(define (solve input)
  (define grid (parse input))
  (define end (find-char grid #\E))
  (bfs grid (find-char grid #\S) (λ (from to) (<= to (add1 from))) (λ (p) (equal? p end))))
