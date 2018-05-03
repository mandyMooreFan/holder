package actions

import game._
import game.cards._
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class AdvanceRunnersTest extends WordSpec with Matchers with TypeCheckedTripleEquals {

  val dumbRange = SafeRange(0 to 0)
  val playerChart = PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange,
    dumbRange)
  val player1 = PlayerCard("123", "Xasz", "Reds", "2018", 5, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
    Array(Position.FIRST_BASE, Position.PITCHER), playerChart)
  val player2: PlayerCard = player1.copy(name = "Mandy", position = Array(Position.SECOND_BASE))
  val player3: PlayerCard = player1.copy(name = "Jujaloope", position = Array(Position.SHORT_STOP))
  val player4: PlayerCard = player1.copy(name = "Gauge", position = Array(Position.THIRD_BASE))
  val player5: PlayerCard = player1.copy(name = "Test", position = Array(Position.LEFT_FIELD))
  val player6: PlayerCard = player1.copy(name = "Test2", position = Array(Position.CENTER_FIELD))
  val player7: PlayerCard = player1.copy(name = "Test3", position = Array(Position.RIGHT_FIELD))
  val player8: PlayerCard = player1.copy(name = "Test4", position = Array(Position.CATCHER))

  val defense = Defense(player1, player2, player4, player3, player8, player5, player6, player7)

  "AdvanceRunnersTest" should {

    "handle" should {
      "Bat->first" in {
        val field = Field(defense, Bases(None, None, None, List(None), Option(player3)))
        val result = AdvanceRunners(field).handle(Result.SINGLE)
        result should ===(Field(defense, Bases(Option(player3), None, None, List(None), None)))
      }

      "Bat->second (double)" in {
        val field = Field(defense, Bases(None, None, None, List(None), Option(player3)))
        val result = AdvanceRunners(field).handle(Result.DOUBLE)
        result should ===(Field(defense, Bases(None, Option(player3), None, List(None, None), None)))
      }

      "Bat->third (triple)" in {
        val field = Field(defense, Bases(None, None, None, List(None), Option(player3)))
        val result = AdvanceRunners(field).handle(Result.TRIPLE)
        result should ===(Field(defense, Bases(None, None, Option(player3), List(None, None, None), None)))
      }

      "Bat->home run" in {
        val field = Field(defense, Bases(None, None, None, List(None), Option(player3)))
        val result = AdvanceRunners(field).handle(Result.HOMER)
        result should ===(Field(defense, Bases(None, None, None, List(None, None, None, Option(player3)), None)))
      }

      "Bases loaded single" in {
        val field = Field(defense, Bases(Option(player4), Option(player5), Option(player6), List(None), Option(player3)))
        val result = AdvanceRunners(field).handle(Result.SINGLE)
        result should ===(Field(defense, Bases(Option(player3), Option(player4), Option(player5), List(Option(player6)), None)))
      }

      "Bases loaded double" in {
        val field = Field(defense, Bases(Option(player4), Option(player5), Option(player6), List(None), Option(player3)))
        val result = AdvanceRunners(field).handle(Result.DOUBLE)
        result should ===(Field(defense, Bases(None, Option(player3), Option(player4), List(Option(player6), Option(player5)), None)))
      }

      "Bases loaded triple" in {
        val field = Field(defense, Bases(Option(player4), Option(player5), Option(player6), List(None), Option(player3)))
        val result = AdvanceRunners(field).handle(Result.TRIPLE)
        result should ===(Field(defense, Bases(None, None, Option(player3), List(Option(player6), Option(player5), Option(player4)), None)))
      }

      "Bases loaded home run" in {
        val field = Field(defense, Bases(Option(player4), Option(player5), Option(player6), List(None), Option(player3)))
        val result = AdvanceRunners(field).handle(Result.HOMER)
        result should ===(Field(defense, Bases(None, None, None, List(Option(player6), Option(player5), Option(player4), Option(player3)), None)))
      }

      "Continuous singles" when {
        val field1 = Field(defense, Bases(None, None, None, List(None), Option(player3)))
        val result1 = AdvanceRunners(field1).handle(Result.SINGLE)
        val field2 = Field(defense, Bases(result1.bases.firstBase, result1.bases.secondBase,
          result1.bases.thirdBase, List(None), Option(player4)))
        val result2 = AdvanceRunners(field2).handle(Result.SINGLE)
        val field3 = Field(defense, Bases(result2.bases.firstBase, result2.bases.secondBase,
          result2.bases.thirdBase, List(None), Option(player5)))
        val result3 = AdvanceRunners(field3).handle(Result.SINGLE)
        val field4 = Field(defense, Bases(result3.bases.firstBase, result3.bases.secondBase,
          result3.bases.thirdBase, List(None), Option(player6)))
        val result4 = AdvanceRunners(field4).handle(Result.SINGLE)

        "result 1" in {
          result1 should ===(Field(defense, Bases(Option(player3), None, None, List(None), None)))
        }
        "result 2" in {
          result2 should ===(Field(defense, Bases(Option(player4), Option(player3), None, List(None), None)))
        }
        "result 3" in {
          result3 should ===(Field(defense, Bases(Option(player5), Option(player4), Option(player3), List(None), None)))
        }
        "result 4" in {
          result4 should ===(Field(defense, Bases(Option(player6), Option(player5), Option(player4), List(Option(player3)), None)))
        }
      }
    }
  }
}