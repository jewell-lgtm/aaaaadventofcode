// Same Dijkstra; the full map is the input tiled 5×5, computed on the fly by risk().
package main

func part2(input string) any {
	return parseCave(input).lowestTotalRisk(5)
}
