package actions

import game._
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class RollPitchTest extends WordSpec with Matchers with TypeCheckedTripleEquals {
  "A RollPitch" when {
    "handle" should {
      "return the pitcher when the roll is greater than the batter's modifier" in {
        val diceRoll = 20
        val pitcher = PlayerCard("123", "Xasz", 5, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
          Array(Position.CATCHER, Position.PITCHER), PlayerChart(None, None, None, None, None, None, None, None, None))
        val batter = PlayerCard("456", "Mandy", 12, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
          Array(Position.CATCHER, Position.PITCHER), PlayerChart(None, None, None, None, None, None, None, None, None))
        RollPitch(pitcher, batter, diceRoll).handle should ===(pitcher)
      }
      "return the batter when the roll is greater than the batter's modifier" in {
        val diceRoll = 7
        val pitcher = PlayerCard("123", "Xasz", 5, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
          Array(Position.CATCHER, Position.PITCHER), PlayerChart(None, None, None, None, None, None, None, None, None))
        val batter = PlayerCard("456", "Mandy", 12, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
          Array(Position.CATCHER, Position.PITCHER), PlayerChart(None, None, None, None, None, None, None, None, None))
        RollPitch(pitcher, batter, diceRoll).handle should ===(batter)
      }
    }
  }
}