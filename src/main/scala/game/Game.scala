package game

import game.player.Player

case class Game(innings: List[Int], homeTeam: Player, awayTeam: Player, scoreBoard: ScoreBoard) {

}

case class ScoreBoard(inning: Int, runs: Int, hits: Int, errors: Int, team: Player) {
}