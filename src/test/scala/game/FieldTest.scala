package game

import game.cards._
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class FieldTest extends WordSpec with Matchers with TypeCheckedTripleEquals {
  "A Field" when {
    val dumbRange = SafeRange(0 to 0)
    val playerCard1 = PlayerCard("123", "Xasz", "Reds", "2018", 8, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
      Array(Position.CATCHER, Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange))
    val defense = Defense(playerCard1, playerCard1)
    val field = Field(defense, Bases(None, None, None, playerCard1))

    "new" must {

      "have a firstBaseman" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(firstBaseman = null)
        }
      }
      "have a SecondBaseman" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(secondBaseman = null)
        }
      }
      "have a batter" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.bases.copy(atBat = null)
        }
      }
    }
  }
}
