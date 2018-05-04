package game.player

import game.cards.{Phase, StrategyCard}
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class PlayerHandTest extends WordSpec with Matchers with TypeCheckedTripleEquals {

  "A Player Hand" when {
    val strategyCard1 = StrategyCard("456", "1", Phase.BEFORE_PITCH, "Test")
    val strategyCard2 = StrategyCard("456", "2", Phase.BEFORE_PITCH, "Test")
    val playerHand = PlayerHand(List(strategyCard1, strategyCard2))

    "discard Card" should {
      "remove the card from the players hand" in {
        val expectedResult = PlayerHand(List(strategyCard2))
        playerHand.discardCard(strategyCard1) should ===(expectedResult)
      }
    }
  }
}