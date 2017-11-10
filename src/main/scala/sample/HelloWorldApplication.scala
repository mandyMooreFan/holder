package sample

import com.mfoody.akkaboot.{Application, Environment}

object HelloWorldApplication {

  def main(args: Array[String]): Unit = {
    new HelloWorldApplication(args).run()
  }

}

class HelloWorldApplication(args: Array[String]) extends Application[HelloWorldConfiguration](args) {
  override def run(configuration: HelloWorldConfiguration, environment: Environment): Environment = {
    environment.route(new HelloWorldRoutes(environment.system, environment.apiDispatcher))
  }
}