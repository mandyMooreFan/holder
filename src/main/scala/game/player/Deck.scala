package game.player

import game.cards.StrategyCard

import scala.util.Random

case class Deck(player: Player, deckList: List[StrategyCard]) {

  def shuffle(): Deck = {
    Deck(player, Random.shuffle(deckList))
  }

  def drawCard(): (StrategyCard, Deck) = {
    (deckList.head, Deck(player, deckList.tail))
  }

  def size: Int = deckList.size
}
