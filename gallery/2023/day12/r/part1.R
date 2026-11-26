# Count arrangements by running a tiny NFA over the record: the states spell
# out the groups as ".###.##.", and a vector of path counts per state is
# advanced one character at a time with whole-vector arithmetic (stay on a dot
# state, or shift right into the next state if the character fits). Reduce()
# folds that step over the characters.

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
    r <- record
    arrangements(r$springs, r$groups)
  }, numeric(1)))
}
