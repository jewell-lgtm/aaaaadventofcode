# Let R's lazy evaluation do the work: every monkey becomes a promise in one
# environment via delayedAssign(), its job turned into a real R call such as
# `pppw / sjmn`. Asking for root forces exactly the promises it depends on,
# each evaluated once, so the environment is both hash map and memo table.

monkey_env <- function(lines) {
  env <- new.env()
  for (line in lines) {
    name <- sub(":.*", "", line)
    job <- strsplit(sub(".*: ", "", line), " ")[[1]]
    expr <- if (length(job) == 1) as.numeric(job)
            else call(job[2], as.name(job[1]), as.name(job[3]))
    do.call(delayedAssign, list(name, expr, env, env))
  }
  env
}

solve <- function(input) get("root", monkey_env(strsplit(input, "\n")[[1]]))
