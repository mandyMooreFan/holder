package baseball

import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class PlayerCardTest extends WordSpec with Matchers with TypeCheckedTripleEquals {

  "A PlayerCard" when {
    val playerCard = PlayerCard("123", "Xasz", 8, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
      Array(Position.CATCHER, Position.PITCHER), PlayerChart(None, None, None, None, None, None, None, None, None))
    "new" must {

      "have a uuid" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(uuid = null)
        }
      }

      "have a non empty uuid" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(uuid = "")
        }
      }

      "have a name" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(name = null)
        }
      }

      "have a non empty name" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(name = "")
        }
      }

      "have a pitch modifier greater than or equal to 0" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(pitchModifier = -1)
        }
      }

      "have a player type" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(playerType = null)
        }
      }

      "have a hand" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(hand = null)
        }
      }

      "have a salary greater than or equal to 0" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(salary = -1)
        }
      }

      "have a position" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(position = null)
        }
      }

      "have a player chart" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(playerChart = null)
        }
      }
    }
  }
}
