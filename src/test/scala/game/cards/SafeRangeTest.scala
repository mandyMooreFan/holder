package game.cards

import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class SafeRangeTest extends WordSpec with Matchers with TypeCheckedTripleEquals {

  "SafeRange safeContains" should {
    "return true" when {
      "an int is within a safeRange" in {
        SafeRange(1 to 3).safeContains(3) should ===(true)
      }
    }
    "return false" when {
      "an int is outside a safeRange" in {
        SafeRange(1 to 3).safeContains(4) should ===(false)
      }
    }
  }
}