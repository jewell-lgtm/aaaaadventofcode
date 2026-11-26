# Pairwise sums via outer(), then match() looks up each pair's missing third
# value in the list all at once: the whole n^2 search is two vectorised calls,
# with a mask so the third entry is distinct from the pair.

solve <- function(input) {
  n <- as.numeric(strsplit(input, "\n")[[1]])
  sums <- outer(n, n, "+")
  third <- matrix(match(2020 - sums, n), nrow(sums))
  ok <- !is.na(third) & row(sums) < col(sums) & third != row(sums) & third != col(sums)
  ij <- which(ok, arr.ind = TRUE)[1, ]
  prod(n[ij]) * n[third[ij[1], ij[2]]]
}
