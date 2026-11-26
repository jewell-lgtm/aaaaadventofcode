# Dijkstra with a dial (bucket) queue: risks are 1..9, so ten circular buckets
# indexed by distance replace a heap. Base R has no priority queue, but buckets
# suit it well: each bucket is settled as one vector, and relaxing its
# neighbours is a vectorised compare-and-update.

neighbours <- function(u, nr, nc) {
  r <- (u - 1) %% nr + 1
  c <- (u - 1) %/% nr + 1
  c(u[r > 1] - 1, u[r < nr] + 1, u[c > 1] - nr, u[c < nc] + nr)
}

lowest_risk <- function(risk) {
  n <- length(risk)
  best <- rep(Inf, n)
  done <- logical(n)
  buckets <- vector("list", 10)
  best[1] <- 0
  buckets[[1]] <- 1L
  d <- 0
  while (!done[n]) {
    slot <- d %% 10 + 1
    u <- unique(buckets[[slot]])
    buckets[slot] <- list(NULL)
    u <- u[!done[u] & best[u] == d]
    done[u] <- TRUE

    # Everything settled at distance d offers d + risk[v]: equal per v, so unique() suffices.
    v <- unique(neighbours(u, nrow(risk), ncol(risk)))
    v <- v[!done[v] & d + risk[v] < best[v]]
    best[v] <- d + risk[v]
    for (group in split(v, risk[v])) {
      s <- (d + risk[group[1]]) %% 10 + 1
      buckets[[s]] <- c(buckets[[s]], group)
    }
    d <- d + 1
  }
  best[n]
}

read_grid <- function(input) {
  digits <- do.call(rbind, strsplit(strsplit(input, "\n")[[1]], ""))
  array(as.integer(digits), dim(digits))
}

solve <- function(input) lowest_risk(read_grid(input))
