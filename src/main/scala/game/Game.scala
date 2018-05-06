package game

import game.player.Player

case class Game(homeTeam: Player, awayTeam: Player, scoreBoard: List[ScoreBoard]) {

  def homeTeamScore: Int = {
    scoreBoard
      .filter { board => board.team == homeTeam }
      .map(filteredScoreboard => filteredScoreboard.runs)
      .sum
  }

  def awayTeamScore: Int = {
    scoreBoard
      .filter { board => board.team == awayTeam }
      .map(filteredScoreboard => filteredScoreboard.runs)
      .sum
  }

  def isGameOver: Boolean = {
    val currentInning = scoreBoard.head.inning

    //HomeTeam Win Condition for 9.5, 10.5, etc
    if (currentInning >= 9.5 && currentInning % 1 != 0 && homeTeamScore > awayTeamScore) {
      true
    }
    //HomeTeam Win Condition for end of an inning
    else if (currentInning > 9.5 && currentInning % 1 == 0 && homeTeamScore != awayTeamScore) {
      true
    }
    else {
      false
    }
  }
}

case class ScoreBoard(inning: Double, runs: Int, hits: Int, errors: Int, team: Player) {
}