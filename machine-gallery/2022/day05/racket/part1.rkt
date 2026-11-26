#lang racket
;; Supply Stacks: read crates column by column from the drawing into an immutable hash
;; of lists (head = top), then for/fold the moves over it. `crane` decides whether the
;; lifted crates flip (CrateMover 9000) or keep their order (9001).
(provide solve run)

(define (parse-stacks drawing)
  (define-values (rows labels) (split-at-right (string-split drawing "\n") 1))
  (for/hash ([i (in-naturals 1)]
             [col (in-range 1 (string-length (first labels)) 4)])
    (values i (for*/list ([row (in-list rows)]
                          #:when (< col (string-length row))
                          [c (in-value (string-ref row col))]
                          #:unless (char=? c #\space))
                c))))

(define (parse-move line)
  (match (string-split line)
    [(list "move" n "from" from "to" to) (map string->number (list n from to))]))

(define (run input crane)
  (match-define (list drawing moves) (string-split input "\n\n"))
  (define final
    (for/fold ([stacks (parse-stacks drawing)])
              ([move (in-list (map parse-move (string-split moves "\n")))])
      (match-define (list n from to) move)
      (define-values (lifted rest) (split-at (hash-ref stacks from) n))
      (hash-update (hash-set stacks from rest) to (λ (s) (append (crane lifted) s)))))
  (list->string (for/list ([i (in-range 1 (add1 (hash-count final)))]
                           #:unless (null? (hash-ref final i)))
                  (first (hash-ref final i)))))

(define (solve input) (run input reverse))
