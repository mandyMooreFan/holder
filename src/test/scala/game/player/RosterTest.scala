package game.player

import game.cards._
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class RosterTest extends WordSpec with Matchers with TypeCheckedTripleEquals {
  "A Roster" when {
    "new" must {
      val dumbRange = SafeRange(0 to 0)
      val playerCard1 = PlayerCard("123", "Xasz", "Reds", "2018", 8, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
        Array(Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange,
          dumbRange, dumbRange))
      val roster = Roster(List(), playerCard1, List())

      "have a battingOrder" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          roster.copy(battingOrder = null)
        }
      }
      "have a startingPitcher" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          roster.copy(startingPitcher = null)
        }
      }
      "have a bench" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          roster.copy(bench = null)
        }
      }
    }
  }
}