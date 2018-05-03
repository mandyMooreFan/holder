package actions

import game.cards.PlayerCard
import game.{Bases, Field, Result}

case class AdvanceRunners(field: Field) {

  def handle(result: Result.Value): (Field, List[Option[PlayerCard]]) = {
    result match {
      case Result.SINGLE =>
        val scoringRunners = List(field.bases.thirdBase).filter(n => n.isDefined)
        (Field(field.defense, Bases(field.bases.atBat, field.bases.firstBase, field.bases.secondBase, None, None)),
          scoringRunners)

      case Result.DOUBLE =>
        val scoringRunners = List(field.bases.secondBase, field.bases.thirdBase).filter(n => n.isDefined)
        (Field(field.defense, Bases(None, field.bases.atBat, field.bases.firstBase, None, None)), scoringRunners)

      case Result.TRIPLE =>
        val scoringRunners = List(field.bases.firstBase, field.bases.secondBase, field.bases.thirdBase).filter(n =>
          n.isDefined)
        (Field(field.defense, Bases(None, None, field.bases.atBat, None, None)), scoringRunners)

      case Result.HOMER =>
        val scoringRunners = List(field.bases.atBat, field.bases.firstBase, field.bases.secondBase,
          field.bases.thirdBase).filter(n => n.isDefined)
        (Field(field.defense, Bases(None, None, None, None, None)), scoringRunners)
    }
  }
}