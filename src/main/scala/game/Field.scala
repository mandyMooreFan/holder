package game

import game.cards.PlayerCard

case class Field(defense: Defense, bases: Bases)

case class Defense(firstBaseman: PlayerCard, secondBaseman: PlayerCard) {
  require(firstBaseman != null, "A first base man is required")
  require(secondBaseman != null, "A secondBaseman is required")
}

case class Bases(firstBase: Option[PlayerCard], secondBase: Option[PlayerCard], thirdBase: Option[PlayerCard],
                 atBat: Option[PlayerCard]) {
  require(atBat != null, "A batter is required")
}

