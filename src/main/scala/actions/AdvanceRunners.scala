package actions

import game.{Bases, Field, Result}

case class AdvanceRunners(field: Field) {

  def handle(result: Result.Value): Field = {
    val newBases = result match {
      case Result.SINGLE => Bases(field.bases.atBat, field.bases.firstBase, field.bases.secondBase,
        List(field.bases.thirdBase), None)
      case Result.DOUBLE => Bases(None, field.bases.atBat, field.bases.firstBase, List(field.bases.thirdBase,
        field.bases.secondBase), None)
      case Result.TRIPLE => Bases(None, None, field.bases.atBat, List(field.bases.thirdBase, field.bases.secondBase,
        field.bases.firstBase), None)
      case Result.HOMER => Bases(None, None, None, List(field.bases.thirdBase, field.bases.secondBase,
        field.bases.firstBase, field.bases.atBat), None)
    }
    Field(field.defense, newBases)
  }
}