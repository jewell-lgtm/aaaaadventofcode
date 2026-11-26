// Jokers join the biggest real group (pattern match on the shape list); J is weakest.
object Part2:
  def jokerShape(cards: String): List[Int] =
    val jokers = cards.count(_ == 'J')
    Part1.shape(cards.filterNot(_ == 'J')) match
      case top :: rest => (top + jokers) :: rest
      case Nil         => List(jokers)

  def solve(input: String): Any = Part1.winnings(Part1.parse(input), jokerShape, "J23456789TQKA")
