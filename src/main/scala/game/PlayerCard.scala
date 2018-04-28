package game

case class PlayerCard(uuid: String, name: String, team: String, season: String, pitchModifier: Int,
                      playerType: PlayerType.Value, hand: Hand.Value, salary: Int, inningsPitched: Option[Int],
                      speed: Option[Int], defense: Option[Int], position: Array[Position.Value],
                      playerChart: PlayerChart) {
  require(uuid != null && uuid.nonEmpty, "Player UUID is required")
  require(name != null && name.nonEmpty, "Player name is required")
  require(team != null && team.nonEmpty, "Player team is required")
  require(season != null && season.nonEmpty, "Player season is required")
  require(pitchModifier >= 0, "Player pitchModifier must be greater than or equal to zero")
  require(playerType != null, "Player playerType is required")
  require(hand != null, "Player hand is required")
  require(salary >= 0, "Player salary must be greater than or equal to zero")
  require(position != null, "Player position is required")
  require(playerChart != null, "Player playerChart is required")
}

case class PlayerChart(outPu: Option[Range], outSo: Option[Range], outGb: Option[Range], outFb: Option[Range],
                       walk: Option[Range], single: Option[Range], double: Option[Range], triple: Option[Range],
                       homer: Option[Range])

object Position extends Enumeration {
  val FIRST_BASE, SECOND_BASE, THIRD_BASE, SHORT_STOP, CATCHER, PITCHER, LEFT_FIELD, CENTER_FIELD, RIGHT_FIELD,
  DH, RELIEF_PITCHER, CLOSER = Value
}

object PlayerChartValues extends Enumeration {
  val OUT_SO, OUT_GB, OUT_FB, WALK, SINGLE, DOUBLE, TRIPLE, HOMER = Value
}

object Hand extends Enumeration {
  val LEFT, RIGHT = Value
}

object PlayerType extends Enumeration {
  val PITCHER, FIELDER = Value
}