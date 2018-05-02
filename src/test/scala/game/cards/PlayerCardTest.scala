package game.cards

import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class PlayerCardTest extends WordSpec with Matchers with TypeCheckedTripleEquals {

  "A PlayerCard" when {
    val dumbRange = SafeRange(0 to 0)
    val playerCard = PlayerCard("123", "Xasz",  "Reds", "2018", 8, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
      Array(Position.CATCHER, Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange))
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

      "have a team" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(team = null)
        }
      }

      "have a non empty team" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(team = "")
        }
      }

      "have a season" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(season = null)
        }
      }

      "have a non empty season" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          playerCard.copy(season = "")
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