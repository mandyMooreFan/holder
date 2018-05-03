package game

import game.cards.{PlayerCard, Position}

case class Field(defense: Defense, bases: Bases)

case class Defense(firstBaseman: PlayerCard, secondBaseman: PlayerCard, thirdBaseman: PlayerCard, shortStop: PlayerCard,
                   catcher: PlayerCard, leftField: PlayerCard, centerField: PlayerCard, rightField: PlayerCard) {
  require(firstBaseman != null && firstBaseman.position.contains(Position.FIRST_BASE), "A first base man is required")
  require(secondBaseman != null && secondBaseman.position.contains(Position.SECOND_BASE), "A secondBaseman is required")
  require(thirdBaseman != null && thirdBaseman.position.contains(Position.THIRD_BASE), "A thirdBaseman is required")
  require(shortStop != null && shortStop.position.contains(Position.SHORT_STOP), "A shortStop is required")
  require(catcher != null && catcher.position.contains(Position.CATCHER), "A catcher is required")
  require(leftField != null && leftField.position.contains(Position.LEFT_FIELD), "A leftField is required")
  require(centerField != null && centerField.position.contains(Position.CENTER_FIELD), "A centerField is required")
  require(rightField != null && rightField.position.contains(Position.RIGHT_FIELD), "A rightField is required")
}

case class Bases(firstBase: Option[PlayerCard], secondBase: Option[PlayerCard], thirdBase: Option[PlayerCard],
                 homePlate: List[Option[PlayerCard]], atBat: Option[PlayerCard]) {
  require(atBat != null, "A batter is required")
}