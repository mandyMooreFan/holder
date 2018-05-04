package game.player

import game.cards.StrategyCard

import scala.util.Random

case class Deck(deckList: List[StrategyCard]) {

  def shuffle(): Deck = {
    Deck(Random.shuffle(deckList))
  }

  def drawCard(): (StrategyCard, Deck) = {
    (deckList.head, Deck(deckList.tail))
  }

  def size: Int = deckList.size
}
