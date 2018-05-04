package game.player

import game.cards.PlayerCard

case class Roster(battingOrder: List[PlayerCard], startingPitcher: PlayerCard, bench: List[PlayerCard]) {
  require(battingOrder != null, "Roster battingOrder is required")
  require(startingPitcher != null, "Roster startingPitcher is required")
  require(bench != null, "Roster bench is required")
}