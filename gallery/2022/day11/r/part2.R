# Same vectorised turns as part 1, but 10000 rounds and no relief. Worry is
# reduced mod the product of all divisors, which preserves every divisibility
# test; values stay below ~1e7, so even old * old (~1e14) is exact in doubles.

last_number <- function(line) as.numeric(sub(".*\\D(\\d+)$", "\\1", line))

parse_monkey <- function(block) {
  lines <- strsplit(block, "\n")[[1]]
  expr <- strsplit(sub(".*= old ", "", lines[3]), " ")[[1]]
  op <- match.fun(expr[1])
  operand <- expr[2]
  list(
    items = as.numeric(regmatches(lines[2], gregexpr("\\d+", lines[2]))[[1]]),
    operation = function(old) op(old, if (operand == "old") old else as.numeric(operand)),
    divisor = last_number(lines[4]),
    if_true = last_number(lines[5]) + 1,
    if_false = last_number(lines[6]) + 1
  )
}

solve <- function(input) {
  monkeys <- lapply(strsplit(input, "\n\n")[[1]], parse_monkey)
  modulus <- prod(vapply(monkeys, `[[`, numeric(1), "divisor"))
  relief <- function(w) w %% modulus
  inspected <- numeric(length(monkeys))

  for (round in seq_len(10000)) {
    for (i in seq_along(monkeys)) {
      m <- monkeys[[i]]
      worry <- relief(m$operation(m$items))
      pass <- worry %% m$divisor == 0
      inspected[i] <- inspected[i] + length(worry)
      monkeys[[i]]$items <- numeric(0)
      monkeys[[m$if_true]]$items <- c(monkeys[[m$if_true]]$items, worry[pass])
      monkeys[[m$if_false]]$items <- c(monkeys[[m$if_false]]$items, worry[!pass])
    }
  }
  prod(head(sort(inspected, decreasing = TRUE), 2))
}
