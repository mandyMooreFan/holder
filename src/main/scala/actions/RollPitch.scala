package actions

import game.PlayerCard

case class RollPitch(pitcher: PlayerCard, batter: PlayerCard, diceRoll: Int) {

  def handle(): PlayerCard = {
    if ((pitcher.pitchModifier + diceRoll) > batter.pitchModifier) {
      pitcher
    } else {
      batter
    }
  }
}
