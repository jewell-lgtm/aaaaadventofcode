# Regex extraction: gregexec() hands back every mul(X,Y) with its capture
# groups as a matrix (row 1 = whole match, rows 2-3 = operands), so the answer
# is one vectorised product-and-sum over two rows.

solve <- function(input) {
  m <- regmatches(input, gregexec("mul\\((\\d{1,3}),(\\d{1,3})\\)", input))[[1]]
  if (length(m) == 0) return(0)
  sum(as.numeric(m[2, ]) * as.numeric(m[3, ]))
}
