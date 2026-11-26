# Dijkstra on the 5x5 tiled map. The tiling is pure matrix arithmetic: each
# tile is (risk + i + j - 1) %% 9 + 1, glued with rbind/cbind. The search is a
# dial (bucket) queue, ten circular buckets for risks 1..9, standing in for
# the heap base R lacks; each bucket is settled and relaxed as one vector.

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

tile <- function(risk, times = 5) {
  shifted <- function(i, j) (risk + i + j - 1) %% 9 + 1
  do.call(rbind, lapply(seq_len(times) - 1, function(i)
    do.call(cbind, lapply(seq_len(times) - 1, function(j) shifted(i, j)))))
}

solve <- function(input) lowest_risk(tile(read_grid(input)))
