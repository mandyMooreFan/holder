package game.player

case class Player(uuid: String, name: String, teamName: String) {
  require(uuid != null && uuid.nonEmpty, "Player UUID is required")
  require(name != null && name.nonEmpty, "Player name is required")
  require(teamName != null && teamName.nonEmpty, "Player teamName is required")
}