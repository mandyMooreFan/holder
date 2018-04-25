package game

import scala.util.Random

case class Deck(player: Player, private var deck: List[StrategyCard]) {

  def shuffle() {
    deck = Random.shuffle(deck)
  }

  def drawCard(): StrategyCard = {
    val top = deck.head
    deck = deck.tail
    top
  }

  def size: Int = deck.size
}
