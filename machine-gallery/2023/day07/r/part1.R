# Each hand becomes a row of sort keys: hand type, then the five card
# strengths. The type score is sum(table(cards)^2), which ranks the seven types
# monotonically (5 kind = 25 ... high card = 5), and a single do.call(order, ...)
# over the key columns ranks every hand at once.

strength <- strsplit("23456789TJQKA", "")[[1]]

type_score <- function(cards) sum(table(cards)^2)

solve <- function(input) {
  fields <- do.call(rbind, strsplit(strsplit(input, "\n")[[1]], " "))
  hands <- strsplit(fields[, 1], "")
  bids <- as.numeric(fields[, 2])

  types <- vapply(hands, type_score, numeric(1))
  cards <- t(vapply(hands, match, integer(5), table = strength))
  ranking <- do.call(order, c(list(types), asplit(cards, 2)))

  sum(bids[ranking] * seq_along(ranking))
}
