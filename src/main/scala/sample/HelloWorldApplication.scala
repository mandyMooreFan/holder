package sample

import com.mfoody.akkaboot.{Application, Environment}
import io.sentry.Sentry

object HelloWorldApplication {

  def main(args: Array[String]): Unit = {
    new HelloWorldApplication(args).run()
  }

}

class HelloWorldApplication(args: Array[String]) extends Application[HelloWorldConfiguration](args) {
  override def run(configuration: HelloWorldConfiguration, environment: Environment): Environment = {
    Sentry.init(configuration.sentry.baseDsn)

    environment.route(new HelloWorldRoutes(environment.system, environment.apiDispatcher))
  }
}