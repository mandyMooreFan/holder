package game

import scala.util.Random

case class Deck(player: Player, deck: List[StrategyCard]) {

  def shuffle(): Deck = {
    Deck(player, Random.shuffle(deck))
  }

  def drawCard(): (StrategyCard, Deck) = {
    (deck.head, Deck(player, deck.tail))
  }

  def size: Int = deck.size
}
