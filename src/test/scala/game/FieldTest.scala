package game

import game.cards._
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class FieldTest extends WordSpec with Matchers with TypeCheckedTripleEquals {
  "A Field" when {
    val allPostions = Array(Position.FIRST_BASE, Position.SECOND_BASE, Position.SHORT_STOP, Position.THIRD_BASE,
      Position.CATCHER, Position.LEFT_FIELD, Position.CENTER_FIELD, Position.RIGHT_FIELD)
    val dumbRange = SafeRange(0 to 0)
    val playerCard1 = PlayerCard("123", "Xasz", "Reds", "2018", 8, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
      allPostions, PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange))
    val defense = Defense(playerCard1, playerCard1, playerCard1, playerCard1, playerCard1, playerCard1, playerCard1,
      playerCard1)
    val field = Field(defense, Bases(None, None, None, List(),Option(playerCard1)))

    val pitchCard = PlayerCard("123", "Xasz", "Reds", "2018", 8, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
      Array(Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange,
        dumbRange))

    "new" must {

      "have a firstBaseman" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(firstBaseman = null)
        }
      }
      "have the firstBaseman position be first base" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(firstBaseman = pitchCard)
        }
      }
      "have a SecondBaseman" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(secondBaseman = null)
        }
      }
      "have the SecondBaseman position be second base" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(secondBaseman = pitchCard)
        }
      }
      "have a ThirdBaseman" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(thirdBaseman = null)
        }
      }
      "have the thirdBaseman position be third base" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(thirdBaseman = pitchCard)
        }
      }
      "have a ShortStop" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(shortStop = null)
        }
      }
      "have the ShortStop position be shortstop" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(shortStop = pitchCard)
        }
      }
      "have a catcher" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(catcher = null)
        }
      }
      "have the catcher position be catcher" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(catcher = pitchCard)
        }
      }
      "have a LeftFielder" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(leftField = null)
        }
      }
      "have the LeftFielder position be left field" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(leftField = pitchCard)
        }
      }
      "have a RightFielder" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(rightField = null)
        }
      }
      "have the RightFielder position be right field" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(rightField = pitchCard)
        }
      }
      "have a CenterFielder" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(centerField = null)
        }
      }
      "have the CenterFielder position be center field" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          field.defense.copy(centerField = pitchCard)
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
