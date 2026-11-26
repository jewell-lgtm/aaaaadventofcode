// Jokers: J is the weakest card for ties but joins the largest group when typing a hand.
package main

func part2(input string) any {
	return totalWinnings(input, "J23456789TQKA", true)
}
