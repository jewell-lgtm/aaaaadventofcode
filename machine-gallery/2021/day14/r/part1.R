# Track pair frequencies, not the polymer: a named vector maps each pair to its
# count, one step rewrites every pair AB -> AC, CB and tapply() re-sums by name.
# Element counts are the first letters of all pairs plus the template's last.

polymerise <- function(input, steps) {
  lines <- strsplit(input, "\n")[[1]]
  template <- strsplit(lines[1], "")[[1]]
  rules <- regmatches(lines[-(1:2)], regexec("(\\w\\w) -> (\\w)", lines[-(1:2)]))
  insert <- setNames(vapply(rules, `[`, "", 3), vapply(rules, `[`, "", 2))

  pairs <- c(table(paste0(head(template, -1), tail(template, -1))))
  for (i in seq_len(steps)) {
    p <- names(pairs)
    mid <- insert[p]
    hit <- !is.na(mid)
    left <- ifelse(hit, paste0(substr(p, 1, 1), mid), p)
    right <- paste0(mid, substr(p, 2, 2))[hit]
    pairs <- tapply(c(pairs, pairs[hit]), c(left, right), sum)
  }

  elements <- tapply(c(pairs, 1), c(substr(names(pairs), 1, 1), tail(template, 1)), sum)
  max(elements) - min(elements)
}

solve <- function(input) polymerise(input, 10)
