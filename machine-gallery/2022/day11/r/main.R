# Harness entry: don't edit. stdin = input, AOC_PART = 1|2, prints the answer last.
source("aoc.R")
source(if (Sys.getenv("AOC_PART") == "2") "part2.R" else "part1.R")

input <- paste(readLines(file("stdin"), warn = FALSE), collapse = "\n")
answer <- solve(input)
cat(if (is.numeric(answer) && answer == round(answer)) sprintf("%.0f", answer) else as.character(answer), "\n", sep = "")
