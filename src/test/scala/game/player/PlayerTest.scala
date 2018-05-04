package game.player

import game.cards._
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class PlayerTest extends WordSpec with Matchers with TypeCheckedTripleEquals {
  "A Player" when {
    val strategyCard1 = StrategyCard("456", "1", Phase.BEFORE_PITCH, "Test")
    val dumbRange = SafeRange(0 to 0)
    val playerCard1 = PlayerCard("123", "Xasz", "Reds", "2018", 8, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
      Array(Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange,
        dumbRange, dumbRange))
    val player = Player("123", "Xasz", "Xasz Fan Club", Deck(List(strategyCard1)), Roster(List(), playerCard1, List()))
    "new" must {

      "have a uuid" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          player.copy(uuid = null)
        }
      }
      "have a uuid value" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          player.copy(uuid = "")
        }
      }
      "have a name" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          player.copy(name = null)
        }
      }
      "have a name value" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          player.copy(name = "")
        }
      }
      "have a teamName" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          player.copy(teamName = null)
        }
      }
      "have a teamName value" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          player.copy(teamName = "")
        }
      }
      "have a deck" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          player.copy(deck = null)
        }
      }
      "have a roster" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          player.copy(roster = null)
        }
      }
    }
  }
}
