package game.player

import game.cards.StrategyCard

case class PlayerHand(cards: List[StrategyCard]) {

  def discardCard(strategyCard: StrategyCard): PlayerHand = {
    PlayerHand(cards.filter(cards => cards != strategyCard))
  }

  def playCard(strategyCard: StrategyCard): Unit = {
    ???
  }
}