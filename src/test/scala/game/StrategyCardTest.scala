package game

import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class StrategyCardTest extends WordSpec with Matchers with TypeCheckedTripleEquals {
  "A Strategy Card" when {
    val strategyCard = StrategyCard("123", "Steal Third", Phase.BEFORE_PITCH, "If this is a card then you do this card")
    "new" must {

      "have a uuid" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          strategyCard.copy(uuid = null)
        }
      }
      "have a uuid value" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          strategyCard.copy(uuid = "")
        }
      }
      "have a name" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          strategyCard.copy(name = null)
        }
      }
      "have a name value" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          strategyCard.copy(name = "")
        }
      }
      "have a play phase" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          strategyCard.copy(playPhase = null)
        }
      }
      "have a playText" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          strategyCard.copy(playText = null)
        }
      }
      "have a playText value" in {
        an[IllegalArgumentException] shouldBe thrownBy {
          strategyCard.copy(playText = "")
        }
      }
    }
  }
}
