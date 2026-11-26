// Three entries: fix each number in turn and look for a pair among the rest.
package part2

import part1.TARGET
import part1.pairProduct
import part1.parse

fun solve(input: String): Any {
    val nums = parse(input)
    return nums.withIndex().firstNotNullOf { (i, a) ->
        pairProduct(nums.drop(i + 1), TARGET - a)?.let { a * it }
    }
}
