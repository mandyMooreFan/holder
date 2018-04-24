package actions

import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class RandomNumbersTest extends WordSpec with Matchers with TypeCheckedTripleEquals {

  "RandomNumbers" should {
    "roll20" should {
      "be an Int" in {
        RandomNumbers.roll20() shouldBe a[java.lang.Integer]
      }
    }

    "coinFlip" should {
      "be a Boolean" in {
        RandomNumbers.coinFlip() shouldBe a[java.lang.Boolean]
      }
    }
  }

}
