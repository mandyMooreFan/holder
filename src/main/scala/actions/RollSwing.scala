package actions

import game.Result
import game.cards.PlayerCard

case class RollSwing(playerCard: PlayerCard, diceRoll: Int) {

  def handle: Result.Value = {
    if (playerCard.playerChart.walk.safeContains(diceRoll)) {
      Result.WALK
    }
    else if (playerCard.playerChart.outSo.safeContains(diceRoll)) {
      Result.OUT_SO
    }
    else if (playerCard.playerChart.outGb.safeContains(diceRoll)) {
      Result.OUT_GB
    }
    else if (playerCard.playerChart.outFb.safeContains(diceRoll)) {
      Result.OUT_FB
    }
    else if (playerCard.playerChart.single.safeContains(diceRoll)) {
      Result.SINGLE
    }
    else if (playerCard.playerChart.double.safeContains(diceRoll)) {
      Result.DOUBLE
    }
    else if (playerCard.playerChart.triple.safeContains(diceRoll)) {
      Result.TRIPLE
    }
    else {
      Result.HOMER
    }
  }
}