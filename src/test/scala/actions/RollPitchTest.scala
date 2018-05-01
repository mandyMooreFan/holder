package actions

import game._
import game.cards._
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class RollPitchTest extends WordSpec with Matchers with TypeCheckedTripleEquals {
  "A RollPitch" when {
    "handle" should {
      "return the pitcher when the roll is greater than the batter's modifier" in {
        val diceRoll = 20
        val dumbRange = SafeRange(0 to 0)
        val pitcher = PlayerCard("123", "Xasz", "Reds", "2018", 5, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
          Array(Position.CATCHER, Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange))
        val batter = PlayerCard("456", "Mandy", "Reds", "2018", 12, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
          Array(Position.CATCHER, Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange))
        RollPitch(pitcher, batter, diceRoll).handle should ===(pitcher)
      }
      "return the batter when the roll is greater than the batter's modifier" in {
        val diceRoll = 7
        val dumbRange = SafeRange(0 to 0)
        val pitcher = PlayerCard("123", "Xasz", "Reds", "2018", 5, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
          Array(Position.CATCHER, Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange))
        val batter = PlayerCard("456", "Mandy", "Reds", "2018", 12, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
          Array(Position.CATCHER, Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange))
        RollPitch(pitcher, batter, diceRoll).handle should ===(batter)
      }
    }
  }
}