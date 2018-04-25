package actions

import game.{Bases, Field}

case class AdvanceRunners(field: Field) {

  // need to add "RESULT" to this function as it handles how bases are advanced.

  def handle(): Field = {
    val newBases = field.bases match {
      case Bases(None, None, None, field.bases.atBat) => Bases(None, None, Option(field.bases.atBat), field.bases.atBat)
      case _ => ???
    }
    Field(field.defense, newBases)
  }
}