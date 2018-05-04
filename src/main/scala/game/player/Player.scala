package game.player

case class Player(uuid: String, name: String, teamName: String, deck: Deck, roster: Roster) {
  require(uuid != null && uuid.nonEmpty, "Player UUID is required")
  require(name != null && name.nonEmpty, "Player name is required")
  require(teamName != null && teamName.nonEmpty, "Player teamName is required")
  require(deck != null, "Player deck is required")
  require(roster != null, "Player roster is required")
}