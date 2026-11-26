#lang racket
;; Camel Cards: `sort` with #:key computing (type strength...) and a small lexicographic
;; comparator. The hand type is a `match` on the group sizes, largest first;
;; with jokers, J is the weakest card and joins the biggest group.
(provide solve winnings)

(define (hand-type cards jokers?)
  (define-values (js others) (partition (λ (c) (and jokers? (char=? c #\J))) cards))
  (define groups (sort (map length (group-by identity others)) >))
  (match (if (null? groups) (list (length js)) (cons (+ (first groups) (length js)) (rest groups)))
    ['(5) 6]
    ['(4 1) 5]
    ['(3 2) 4]
    ['(3 1 1) 3]
    ['(2 2 1) 2]
    ['(2 1 1 1) 1]
    [_ 0]))

(define (hand-key hand jokers?)
  (define order (if jokers? "J23456789TQKA" "23456789TJQKA"))
  (define cards (string->list hand))
  (cons (hand-type cards jokers?)
        (for/list ([c cards]) (index-of (string->list order) c))))

(define (lex<? a b)
  (match* (a b)
    [((cons x xs) (cons y ys)) (or (< x y) (and (= x y) (lex<? xs ys)))]
    [(_ _) #f]))

(define (winnings input jokers?)
  (define hands
    (for/list ([line (string-split input "\n")])
      (match-define (list hand bid) (string-split line))
      (cons (hand-key hand jokers?) (string->number bid))))
  (for/sum ([h (sort hands lex<? #:key car)] [rank (in-naturals 1)])
    (* rank (cdr h))))

(define (solve input) (winnings input #f))
