package game

import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class DeckTest extends WordSpec with Matchers with TypeCheckedTripleEquals {

  "DeckTest" should {

    "A Strategy Card deck" when {

      val strategyCard1 = StrategyCard("456", "1", Phase.BEFORE_PITCH, "Test")
      val strategyCard2 = StrategyCard("456", "2", Phase.BEFORE_PITCH, "Test")

      "drawCard" should {

        "return the top card" in {
          val player = Player("123", "Xasz", "Xasz Fan Club")
          val (card, deck) = Deck(player, List(strategyCard1, strategyCard2)).drawCard()
          card should ===(strategyCard1)
          deck should ===(Deck(player, List(strategyCard2)))
        }

        "decrement the deck size" in {
          val deck = Deck(Player("123", "Xasz", "Xasz Fan Club"), List(strategyCard1, strategyCard2))
          val deck_size = deck.size
          val deck2 = deck.drawCard()._2
          deck2.size should ===(deck_size - 1)
        }
      }

      "shuffle" should {
        "contain the same number of cards" in {
          val deck = Deck(Player("123", "Xasz", "Xasz Fan Club"), List(strategyCard1, strategyCard2))
          val deck2 = deck.shuffle()
          deck2.size should ===(deck.size)
        }
      }
    }
  }
}
