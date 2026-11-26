# Breadth-first search one whole frontier at a time, run backwards from E: the
# distance matrix then holds the shortest climb from every square, and the best
# trail is just the minimum over all the elevation-'a' cells.

# Every (from, to) pair of orthogonal neighbours for cells u of an nr x nc matrix.
neighbour_pairs <- function(u, nr, nc) {
  r <- (u - 1) %% nr + 1
  c <- (u - 1) %/% nr + 1
  cbind(from = c(u[r > 1], u[r < nr], u[c > 1], u[c < nc]),
        to   = c(u[r > 1] - 1, u[r < nr] + 1, u[c > 1] - nr, u[c < nc] + nr))
}

# Steps from every cell to `goal`, walking edges in reverse: we may step down
# at most one, i.e. the original move up was at most one.
distances_to <- function(heights, goal) {
  dist <- array(NA_integer_, dim(heights))
  dist[goal] <- 0L
  frontier <- goal
  while (length(frontier)) {
    e <- neighbour_pairs(frontier, nrow(heights), ncol(heights))
    ok <- is.na(dist[e[, "to"]]) & heights[e[, "from"]] - heights[e[, "to"]] <= 1
    nxt <- unique(e[ok, "to"])
    dist[nxt] <- dist[frontier[1]] + 1L
    frontier <- nxt
  }
  dist
}

solve <- function(input) {
  grid <- do.call(rbind, strsplit(strsplit(input, "\n")[[1]], ""))
  start <- which(grid == "S")
  goal <- which(grid == "E")
  grid[start] <- "a"
  grid[goal] <- "z"
  heights <- array(match(grid, letters), dim(grid))

  dist <- distances_to(heights, goal)
  min(dist[heights == 1], na.rm = TRUE)
}
