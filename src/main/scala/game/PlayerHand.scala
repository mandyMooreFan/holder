package game

case class PlayerHand(player: Player, cards: List[StrategyCard]) {

  def discardCard(strategyCard: StrategyCard): PlayerHand = {
    PlayerHand(player, cards.filter(cards => cards != strategyCard))
  }

  def playCard(strategyCard: StrategyCard): Unit = {
    ???
  }
}