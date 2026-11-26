# Harness helpers.
#   example          TRUE when running an example (aoc test)
#   arg("size", 71)  example-specific constant from examples.toml `args`, else the default

example <- Sys.getenv("AOC_EXAMPLE") == "1"

# Flat JSON object {"k": 1, "s": "x", "b": true}: enough for AOC_ARGS, no packages needed.
.aoc_args <- local({
  json <- Sys.getenv("AOC_ARGS", "{}")
  pairs <- regmatches(json, gregexpr('"[^"]+"\\s*:\\s*("[^"]*"|[^,}]+)', json))[[1]]
  keys <- sub('^"([^"]+)".*$', "\\1", pairs)
  vals <- trimws(sub('^"[^"]+"\\s*:\\s*', "", pairs))
  setNames(as.list(gsub('^"|"$', "", vals)), keys)
})

arg <- function(name, default) {
  v <- .aoc_args[[name]]
  if (is.null(v)) return(default)
  if (is.logical(default)) v == "true" else as(v, class(default))
}
