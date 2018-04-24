package game

case class StrategyCard(uuid: String, name: String, playPhase: Phase.Value, playText: String) {
  require(uuid != null && uuid.nonEmpty, "StrategyCard UUID is required")
  require(name != null && name.nonEmpty, "StrategyCard name is required")
  require(playPhase != null, "StrategyCard playPhase is required")
  require(playText != null && playText.nonEmpty, "StrategyCard playText is required")
}

object Phase extends Enumeration {
  val BEFORE_PITCH, AFTER_THIRD_OUT, DOUBLE_PLAY_ATTEMPT, PLAY_ON_HOMER = Value
}