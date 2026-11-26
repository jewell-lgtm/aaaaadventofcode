// Unfold each row five times; the memo keeps it polynomial.
package part2

import part1.rows

fun solve(input: String): Any = rows(input).sumOf { it.unfolded(5).arrangements() }
