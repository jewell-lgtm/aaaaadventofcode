# outer() builds the full table of pairwise sums in one call; blanking the
# lower triangle and diagonal keeps each unordered pair of distinct entries
# once, and which(arr.ind = TRUE) reads off the matching row/column.

solve <- function(input) {
  n <- as.numeric(strsplit(input, "\n")[[1]])
  sums <- outer(n, n, "+")
  sums[lower.tri(sums, diag = TRUE)] <- NA
  hit <- which(sums == 2020, arr.ind = TRUE)[1, ]
  prod(n[hit])
}
