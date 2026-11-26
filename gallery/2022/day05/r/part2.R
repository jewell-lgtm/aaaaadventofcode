# Stacks as a list of character vectors, top crate first. The drawing is read
# column-wise with substr() at the fixed crate positions (2, 6, 10, ...); a move
# is head()/tail() slicing, and the CrateMover 9001 keeps the block's order.

parse_stacks <- function(drawing) {
  rows <- head(drawing, -1)
  n <- length(strsplit(trimws(tail(drawing, 1)), " +")[[1]])
  crates <- vapply(4 * seq_len(n) - 2, function(p) substr(rows, p, p), character(length(rows)))
  crates <- matrix(crates, nrow = length(rows))
  lapply(seq_len(n), function(j) crates[crates[, j] %in% LETTERS, j])
}

parse_moves <- function(lines) {
  nums <- regmatches(lines, gregexpr("\\d+", lines))
  lapply(nums, as.integer)
}

solve <- function(input) {
  lines <- strsplit(input, "\n")[[1]]
  blank <- which(lines == "")[1]
  stacks <- parse_stacks(lines[seq_len(blank - 1)])

  for (m in parse_moves(lines[-seq_len(blank)])) {
    k <- m[1]; from <- m[2]; to <- m[3]
    lifted <- head(stacks[[from]], k)
    stacks[[from]] <- tail(stacks[[from]], -k)
    stacks[[to]] <- c(lifted, stacks[[to]])
  }
  paste(vapply(stacks, function(s) if (length(s)) s[1] else "", ""), collapse = "")
}
