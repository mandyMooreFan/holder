package game.cards

case class PlayerChart(outSo: SafeRange, outGb: SafeRange, outFb: SafeRange, walk: SafeRange, single: SafeRange,
                       double: SafeRange, triple: SafeRange, homer: SafeRange)

class SafeRange(range: Range) {
  def safeContains(i: Int): Boolean = range contains i
}

object SafeRange {
  def apply(range: Range) = new SafeRange(range)
}