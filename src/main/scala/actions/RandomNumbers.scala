package actions

import scala.util.Random

object RandomNumbers {

  private val rand = new Random()

  def roll20(): Int = {
    rand.nextInt(20) + 1
  }

  def coinFlip(): Boolean = {
    rand.nextBoolean()
  }

}