#lang racket
;; Extended Polymerization: never build the polymer. Count adjacent pairs in an
;; immutable hash; each step, pair (a . b) with rule c becomes (a . c) and (c . b).
;; Element counts = first letter of every pair, plus the template's last letter.
(provide solve spread)

(define (tally kvs)
  (for/fold ([h (hash)]) ([kv (in-list kvs)])
    (hash-update h (car kv) (λ (n) (+ n (cdr kv))) 0)))

(define (spread input steps)
  (match-define (list template rule-block) (string-split input "\n\n"))
  (define rules
    (for/hash ([line (string-split rule-block "\n")])
      (match (string->list line)
        [(list a b _ ... c) (values (cons a b) c)])))
  (define letters (string->list template))
  (define (step pairs)
    (tally (for*/list ([(pair n) (in-hash pairs)]
                       [new (in-list (match (hash-ref rules pair #f)
                                       [#f (list pair)]
                                       [c (list (cons (car pair) c) (cons c (cdr pair)))]))])
             (cons new n))))
  (define final
    (for/fold ([pairs (tally (for/list ([a letters] [b (cdr letters)]) (cons (cons a b) 1)))])
              ([_ (in-range steps)])
      (step pairs)))
  (define counts
    (hash-values (tally (cons (cons (last letters) 1)
                              (for/list ([(pair n) (in-hash final)]) (cons (car pair) n))))))
  (- (apply max counts) (apply min counts)))

(define (solve input) (spread input 10))
