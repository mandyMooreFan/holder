package actions

case class EndInning(inning: Double) {

  def handle(): Double = {
    inning + .5
  }
}
