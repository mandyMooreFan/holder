package baseball

object Field {

  case class Defense(firstBaseman: PlayerCard, secondBaseman: PlayerCard) {
    require(firstBaseman != null, "A first base man is required")
  }

  case class Bases(firstBase: Option[PlayerCard], secondBase: Option[PlayerCard], thirdBase: Option[PlayerCard], atBat: PlayerCard) {
    require(atBat != null, "A batter is required")
  }

}
