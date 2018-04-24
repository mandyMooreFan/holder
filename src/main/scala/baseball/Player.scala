package baseball

case class Player(uuid: String, name: String, position: Array[Position], playerChart: PlayerChart) {
  require(uuid != null && uuid.nonEmpty, "Player UUID is required")
  require(name != null && name.nonEmpty, "Player name is required")
  require(position != null, "Player position is required")
  require(playerChart != null, "Player playerChart is required")
}

case class PlayerChart()

class Position extends Enumeration {
  val FIRST_BASE, SECOND_BASE, THIRD_BASE, SHORT_STOP, CATCHER, PITCHER, LEFT_FIELD, CENTER_FIELD, RIGHT_FIELD,
  DH, RELIEF_PITCHER, CLOSER = Value
}