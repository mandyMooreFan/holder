package sample

import akka.actor.ActorSystem
import akka.http.scaladsl.server.Route
import com.mfoody.akkaboot.ScalaRouteBuilder

import scala.concurrent.ExecutionContext
import scala.util.Random

class HelloWorldRoutes(system: ActorSystem, executionContext: ExecutionContext)
  extends ScalaRouteBuilder(system, executionContext) {

  override def route: Route = get {
    pathPrefix("hellos") {
      parameter("fail".?) { fail =>
        completeWithActor {
          if (fail.isDefined) {
            throw new Exception("Something bad always happened")
          } else {
            "Hello Worlds"
          }
        }
      }
    }
  }

}