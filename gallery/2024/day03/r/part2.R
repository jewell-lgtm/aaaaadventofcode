# Tokenise mul(X,Y), do() and don't() in one regex, then carry the last switch
# forward without a loop: cummax() over the positions of switch tokens gives,
# for every token, the index of the most recent do()/don't() before it.

solve <- function(input) {
  tokens <- regmatches(input, gregexpr("mul\\(\\d{1,3},\\d{1,3}\\)|do\\(\\)|don't\\(\\)", input))[[1]]
  switch_to <- ifelse(tokens == "do()", TRUE, ifelse(tokens == "don't()", FALSE, NA))
  last_switch <- cummax(ifelse(is.na(switch_to), 0L, seq_along(tokens)))
  enabled <- c(TRUE, switch_to)[last_switch + 1]

  muls <- tokens[enabled & is.na(switch_to)]
  operands <- regmatches(muls, gregexpr("\\d+", muls))
  sum(vapply(operands, function(xy) prod(as.numeric(xy)), numeric(1)))
}
