package game

import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class FieldTest extends WordSpec with Matchers with TypeCheckedTripleEquals {
  "A Field" when {
    val playerCard1 = PlayerCard("123", "Xasz", 8, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
      Array(Position.CATCHER, Position.PITCHER), PlayerChart(None, None, None, None, None, None, None, None, None))
    val defense = Defense(playerCard1, playerCard1)
    val field = Field(defense, Bases(None, None, None, playerCard1))

    "new" must {

      "have a uuid" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(firstBaseman = null)
        }
      }
    }
  }
}
