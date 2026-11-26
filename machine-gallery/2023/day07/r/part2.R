# Same sort-key ranking as part 1, with J now the weakest card. A joker
# always does best by joining the largest group of the other cards, so the
# type is the count vector with the jokers added to its maximum.

strength <- strsplit("J23456789TQKA", "")[[1]]

type_score <- function(cards) {
  counts <- sort(as.vector(table(cards[cards != "J"])), decreasing = TRUE)
  jokers <- sum(cards == "J")
  if (length(counts) == 0) counts <- 0
  counts[1] <- counts[1] + jokers
  sum(counts^2)
}

solve <- function(input) {
  fields <- do.call(rbind, strsplit(strsplit(input, "\n")[[1]], " "))
  hands <- strsplit(fields[, 1], "")
  bids <- as.numeric(fields[, 2])

  types <- vapply(hands, type_score, numeric(1))
  cards <- t(vapply(hands, match, integer(5), table = strength))
  ranking <- do.call(order, c(list(types), asplit(cards, 2)))

  sum(bids[ranking] * seq_along(ranking))
}
