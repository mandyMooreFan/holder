package actions

import game._
import game.cards._
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class AdvanceRunnersTest extends WordSpec with Matchers with TypeCheckedTripleEquals {

  val dumbRange = SafeRange(0 to 0)
  val player1 = PlayerCard("123", "Xasz", "Reds", "2018", 5, PlayerType.PITCHER, Hand.LEFT, 1, None, None, None,
    Array(Position.FIRST_BASE, Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange,
      dumbRange, dumbRange, dumbRange))
  val player2 = PlayerCard("456", "Mandy", "Reds", "2018", 10, PlayerType.FIELDER, Hand.LEFT, 1, None, None, None,
    Array(Position.SECOND_BASE, Position.PITCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange,
      dumbRange, dumbRange, dumbRange))
  val player3 = PlayerCard("789", "Jujalope", "Blues", "2018", 10, PlayerType.FIELDER, Hand.RIGHT, 1, None, None, None,
    Array(Position.CATCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange,
      dumbRange))
  val player4 = PlayerCard("321", "Gauge", "Blues", "2018", 10, PlayerType.FIELDER, Hand.RIGHT, 1, None, None, None,
    Array(Position.CATCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange,
      dumbRange))
  val player5 = PlayerCard("654", "Alef", "Blues", "2018", 10, PlayerType.FIELDER, Hand.RIGHT, 1, None, None, None,
    Array(Position.CATCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange,
      dumbRange))
  val player6 = PlayerCard("987", "Neele", "Blues", "2018", 15, PlayerType.FIELDER, Hand.RIGHT, 1, None, None, None,
    Array(Position.CATCHER), PlayerChart(dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange, dumbRange,
      dumbRange))

  val defense = Defense(player1, player2)

  "AdvanceRunnersTest" should {

    "handle" should {
      "Bat->first" in {
        val field = Field(defense, Bases(None, None, None, Option(player3)))
        val result = AdvanceRunners(field).handle(Result.SINGLE)
        result should ===((Field(defense, Bases(Option(player3), None, None, None)), List()))
      }

      "Bat->second (double)" in {
        val field = Field(defense, Bases(None, None, None, Option(player3)))
        val result = AdvanceRunners(field).handle(Result.DOUBLE)
        result should ===((Field(defense, Bases(None, Option(player3), None, None)), List()))
      }

      "Bat->third (triple)" in {
        val field = Field(defense, Bases(None, None, None, Option(player3)))
        val result = AdvanceRunners(field).handle(Result.TRIPLE)
        result should ===((Field(defense, Bases(None, None, Option(player3), None)), List()))
      }

      "Bat->home run" in {
        val field = Field(defense, Bases(None, None, None, Option(player3)))
        val result = AdvanceRunners(field).handle(Result.HOMER)
        result should ===((Field(defense, Bases(None, None, None, None)), List(Option(player3))))
      }

      "Bases loaded single" in {
        val field = Field(defense, Bases(Option(player4), Option(player5), Option(player6), Option(player3)))
        val result = AdvanceRunners(field).handle(Result.SINGLE)
        result should ===((Field(defense, Bases(Option(player3), Option(player4), Option(player5), None)),
          List(Option(player6))))
      }

      "Bases loaded double" in {
        val field = Field(defense, Bases(Option(player4), Option(player5), Option(player6), Option(player3)))
        val result = AdvanceRunners(field).handle(Result.DOUBLE)
        result should ===((Field(defense, Bases(None, Option(player3), Option(player4), None)), List(Option(player5),
          Option(player6))))
      }

      "Bases loaded triple" in {
        val field = Field(defense, Bases(Option(player4), Option(player5), Option(player6), Option(player3)))
        val result = AdvanceRunners(field).handle(Result.TRIPLE)
        result should ===((Field(defense, Bases(None, None, Option(player3), None)), List(Option(player4),
          Option(player5), Option(player6))))
      }

      "Bases loaded home run" in {
        val field = Field(defense, Bases(Option(player4), Option(player5), Option(player6), Option(player3)))
        val result = AdvanceRunners(field).handle(Result.HOMER)
        result should ===((Field(defense, Bases(None, None, None, None)), List(Option(player3), Option(player4),
          Option(player5), Option(player6))))
      }

      "Continuous singles" in {
        val field1 = Field(defense, Bases(None, None, None, Option(player3)))
        val result1 = AdvanceRunners(field1).handle(Result.SINGLE)
        result1 should ===((Field(defense, Bases(Option(player3), None, None, None)), List()))
        val field2 = Field(defense, Bases(result1._1.bases.firstBase, result1._1.bases.secondBase,
          result1._1.bases.thirdBase, Option(player4)))
        val result2 = AdvanceRunners(field2).handle(Result.SINGLE)
        result2 should ===((Field(defense, Bases(Option(player4), Option(player3), None, None)), List()))
        val field3 = Field(defense, Bases(result2._1.bases.firstBase, result2._1.bases.secondBase,
          result2._1.bases.thirdBase, Option(player5)))
        val result3 = AdvanceRunners(field3).handle(Result.SINGLE)
        result3 should ===((Field(defense, Bases(Option(player5), Option(player4), Option(player3), None)), List()))
        val field4 = Field(defense, Bases(result3._1.bases.firstBase, result3._1.bases.secondBase,
          result3._1.bases.thirdBase, Option(player6)))
        val result4 = AdvanceRunners(field4).handle(Result.SINGLE)
        result4 should ===((Field(defense, Bases(Option(player6), Option(player5), Option(player4), None)),
          List(Option(player3))))
      }
    }
  }
}
