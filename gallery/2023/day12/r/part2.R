# The same NFA count as part 1 on the records unfolded five times. Counting
# paths instead of enumerating them keeps each row linear in its length, and
# the totals (~1e13) are well inside the 2^53 range where doubles are exact.

parse_record <- function(line) {
  parts <- strsplit(line, " ")[[1]]
  list(springs = parts[1], groups = as.integer(strsplit(parts[2], ",")[[1]]))
}

arrangements <- function(springs, groups) {
  states <- strsplit(paste0(".", paste(strrep("#", groups), collapse = "."), "."), "")[[1]]
  is_dot <- states == "."
  step <- function(count, ch) {
    can_dot <- ch != "#"
    can_hash <- ch != "."
    fits <- ifelse(is_dot, can_dot, can_hash)
    count * (is_dot & can_dot) + c(0, head(count, -1)) * fits
  }
  start <- c(1, numeric(length(states) - 1))
  final <- Reduce(step, strsplit(springs, "")[[1]], start)
  sum(tail(final, 2))
}

solve <- function(input) {
  records <- lapply(strsplit(input, "\n")[[1]], parse_record)
  sum(vapply(records, function(record) {
    r <- list(springs = paste(rep(record$springs, 5), collapse = "?"), groups = rep(record$groups, 5))
    arrangements(r$springs, r$groups)
  }, numeric(1)))
}
