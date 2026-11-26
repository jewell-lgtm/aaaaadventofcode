#lang racket
;; Monkey in the Middle: `match` with regexp patterns pulls each block apart into a
;; struct whose op is a closure; rounds for/fold over an immutable hash of held items.
;; `relief` is quotient by 3 here, modulo the product of divisors in part 2.
(provide solve (struct-out monkey) monkey-business)

(struct monkey (items op divisor on-true on-false))

(define (parse-monkey block)
  (match (string-split block "\n")
    [(list _
           (pregexp #px"items: (.*)" (list _ items))
           (pregexp #px"new = old (.) (\\w+)" (list _ op arg))
           (pregexp #px"by (\\d+)" (list _ div))
           (pregexp #px"monkey (\\d+)" (list _ t))
           (pregexp #px"monkey (\\d+)" (list _ f)))
     (monkey (map string->number (string-split items ", "))
             (match* (op arg)
               [("*" "old") (λ (x) (* x x))]
               [("*" n) (λ (x) (* x (string->number n)))]
               [("+" n) (λ (x) (+ x (string->number n)))])
             (string->number div) (string->number t) (string->number f))]))

(define (monkey-business input rounds relief)
  (define monkeys (list->vector (map parse-monkey (string-split input "\n\n"))))
  (define relieve (relief (vector->list monkeys)))
  (define (turn i state)
    (match-define (cons held seen) state)
    (match-define (monkey _ op divisor on-true on-false) (vector-ref monkeys i))
    (define items (hash-ref held i))
    (cons (for/fold ([held (hash-set held i '())]) ([w (in-list items)])
            (define worry (relieve (op w)))
            (define target (if (zero? (modulo worry divisor)) on-true on-false))
            (hash-update held target (λ (l) (append l (list worry)))))
          (hash-update seen i (λ (n) (+ n (length items))) 0)))
  (define start (cons (for/hash ([(m i) (in-indexed monkeys)]) (values i (monkey-items m))) (hash)))
  (define final
    (for*/fold ([state start]) ([_ (in-range rounds)] [i (in-range (vector-length monkeys))])
      (turn i state)))
  (apply * (take (sort (hash-values (cdr final)) >) 2)))

(define (solve input) (monkey-business input 20 (λ (_) (λ (w) (quotient w 3)))))
