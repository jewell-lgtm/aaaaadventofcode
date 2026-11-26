# Each monkey is a list (items, operation closure, divisor, targets). A turn
# is fully vectorised: apply the operation to the monkey's whole item vector,
# divide by 3, and split the results between the two targets with a logical
# mask. Rounds and turns are honest loops, since monkeys act in sequence.

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
  relief <- function(w) floor(w / 3)
  inspected <- numeric(length(monkeys))

  for (round in seq_len(20)) {
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
