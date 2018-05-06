package game

import game.cards._
import game.player.{Deck, Player, Roster}
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class GameTest extends WordSpec with Matchers with TypeCheckedTripleEquals {

  "A Game" should {
    val strategyCard2 = StrategyCard("456", "2", Phase.BEFORE_PITCH, "Test")
    val dumbRange = SafeRange(0 to 0)
    val playerCard1 = PlayerCard("123", "Xasz", "Reds", "2018", 8, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
      Array(Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange,
        dumbRange, dumbRange))
    val player = Player("123", "Xasz", "Xasz Fan Club", Deck(List(strategyCard2)), Roster(List(), playerCard1, List()))
    val player2 = Player("223", "Mandy", "Xasz Fan Club #1", Deck(List(strategyCard2)), Roster(List(),
      playerCard1, List()))

    val game = Game(player, player2, List(ScoreBoard(1, 1, 0, 0, player), ScoreBoard(1.5, 5, 0, 0, player2),
      ScoreBoard(2, 3, 0, 0, player), ScoreBoard(2.5, 8, 3, 0, player2)))
    "homeTeamScore" should {
      "return the score of just the home team" in {
        game.homeTeamScore should ===(4)
      }
    }
    "awayTeamScore" should {
      "return the score of just the home team" in {
        game.awayTeamScore should ===(13)
      }
    }

    "game should not end in the bottom of the 9th if the homeTeam does not have more runs" in {
      val gameTest = game.copy(scoreBoard = List(ScoreBoard(9.5,0,0,0, player)))
      gameTest.isGameOver should ===(false)
    }
    "game should end in the bottom of the 9th if the homeTeam hs more runs" in {
      val gameTest = game.copy(scoreBoard = List(ScoreBoard(9.5,2,0,0, player)))
      gameTest.isGameOver should ===(true)
    }
    "game should not end in the top of the 10th if the away team is ahead" in {
      val gameTest = game.copy(scoreBoard = List(ScoreBoard(10.5,2,0,0, player2)))
      gameTest.isGameOver should ===(false)
    }
    "game should not end in the bottom of the 10th if the away team is ahead" in {
      val gameTest = game.copy(scoreBoard = List(ScoreBoard(10.5,2,0,0, player2)))
      gameTest.isGameOver should ===(false)
    }
    "game should not in the bottom of the 10th if the awayTeam hs more runs" in {
      val gameTest = game.copy(scoreBoard = List(ScoreBoard(10,2,0,0, player2)))
      gameTest.isGameOver should ===(true)
    }
  }
}