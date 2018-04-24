package baseball

object Field {

  case class Defense(firstBaseman: Player, secondBaseman: Player) {
    require(firstBaseman != null, "A first base man is required")
  }

  case class Bases(firstBase: Option[Player], secondBase: Option[Player], thirdBase: Option[Player], atBat: Player) {
    require(atBat != null, "A batter is required")
  }

}
