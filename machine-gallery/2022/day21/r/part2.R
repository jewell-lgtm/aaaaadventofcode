# Monkeys are lazy promises in an environment (as in part 1), so any subtree
# that doesn't involve humn evaluates on demand. Walk the path from root down
# to humn, inverting each operation against the known sibling; going top-down
# keeps every intermediate an exact integer.

parse_jobs <- function(lines) {
  names <- sub(":.*", "", lines)
  setNames(strsplit(sub(".*: ", "", lines), " "), names)
}

monkey_env <- function(jobs) {
  env <- new.env()
  for (name in names(jobs)) {
    job <- jobs[[name]]
    expr <- if (length(job) == 1) as.numeric(job)
            else call(job[2], as.name(job[1]), as.name(job[3]))
    do.call(delayedAssign, list(name, expr, env, env))
  }
  env
}

# Monkeys from root down to humn, found by following parent links up from humn.
path_to_humn <- function(jobs) {
  ops <- Filter(function(j) length(j) == 3, jobs)
  parent <- setNames(rep(names(ops), each = 2), unlist(lapply(ops, `[`, c(1, 3))))
  path <- "humn"
  while (path[1] != "root") path <- c(parent[[path[1]]], path)
  path
}

# Value x such that `x op known` (x on the left) or `known op x` equals target.
invert <- function(op, target, known, x_on_left) {
  switch(op,
    "+" = target - known,
    "*" = target / known,
    "-" = if (x_on_left) target + known else known - target,
    "/" = if (x_on_left) target * known else known / target)
}

solve <- function(input) {
  jobs <- parse_jobs(strsplit(input, "\n")[[1]])
  env <- monkey_env(jobs)
  path <- path_to_humn(jobs)

  target <- NULL
  for (k in seq_len(length(path) - 1)) {
    job <- jobs[[path[k]]]
    x_on_left <- job[1] == path[k + 1]
    known <- get(if (x_on_left) job[3] else job[1], env)
    target <- if (is.null(target)) known else invert(job[2], target, known, x_on_left)
  }
  target
}
