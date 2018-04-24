package game

import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class PlayerTest extends WordSpec with Matchers with TypeCheckedTripleEquals {
  "A Player" when {
    val player = Player("123", "Xasz", "Xasz Fan Club")
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
    }
  }
}
