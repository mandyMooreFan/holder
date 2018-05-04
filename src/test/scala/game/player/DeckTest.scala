package game.player

import game.cards._
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class DeckTest extends WordSpec with Matchers with TypeCheckedTripleEquals {

  "DeckTest" should {

    "A Strategy Card deck" when {

      val strategyCard1 = StrategyCard("456", "1", Phase.BEFORE_PITCH, "Test")
      val strategyCard2 = StrategyCard("456", "2", Phase.BEFORE_PITCH, "Test")
      val dumbRange = SafeRange(0 to 0)
      val playerCard1 = PlayerCard("123", "Xasz", "Reds", "2018", 8, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
        Array(Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange,
          dumbRange, dumbRange))
      "drawCard" should {

        "return the top card" in {
          val player = Player("123", "Xasz", "Xasz Fan Club", Deck(List(strategyCard1)), Roster(List(), playerCard1, List()))
          val (card, deck) = Deck(List(strategyCard1, strategyCard2)).drawCard()
          card should ===(strategyCard1)
          deck should ===(Deck(List(strategyCard2)))
        }

        "decrement the deck size" in {
          val deck = Deck(List(strategyCard1, strategyCard2))
          val deck_size = deck.size
          val deck2 = deck.drawCard()._2
          deck2.size should ===(deck_size - 1)
        }
      }

      "shuffle" should {
        "contain the same number of cards" in {
          val deck = Deck(List(strategyCard1, strategyCard2))
          val deck2 = deck.shuffle()
          deck2.size should ===(deck.size)
        }
      }
    }
  }
}
