package actions

import game.Result
import game.cards._
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class RollSwingTest extends WordSpec with Matchers with TypeCheckedTripleEquals {
  "A RollSwing test" when {
    val playerChart = PlayerChart(SafeRange(1 to 2), SafeRange(2 to 3), SafeRange(4 to 5), SafeRange(6 to 7),
      SafeRange(8 to 9), SafeRange(10 to 11), SafeRange(12 to 13), SafeRange(14 to 100))
    val player = PlayerCard("123", "Xasz", "Reds", "2018", 5, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
      Array(Position.CATCHER, Position.PITCHER), playerChart)
    "called" should {
      "return a Strike Out when the range is in between the numbers" in {
        RollSwing(player, 2).handle should ===(Result.OUT_SO)
      }
      "return a ground ball out when the range is in between the numbers" in {
        RollSwing(player, 3).handle should ===(Result.OUT_GB)
      }
      "return a fly ball out when the range is in between the numbers" in {
        RollSwing(player, 4).handle should ===(Result.OUT_FB)
      }
      "return a walk when the range is in between the numbers" in {
        RollSwing(player, 6).handle should ===(Result.WALK)
      }
      "return a single when the range is in between the numbers" in {
        RollSwing(player, 8).handle should ===(Result.SINGLE)
      }
      "return a double when the range is in between the numbers" in {
        RollSwing(player, 10).handle should ===(Result.DOUBLE)
      }
      "return a triple when the range is in between the numbers" in {
        RollSwing(player, 12).handle should ===(Result.TRIPLE)
      }
      "return a home run when the range is in between the numbers" in {
        RollSwing(player, 15).handle should ===(Result.HOMER)
      }
    }
  }
}
