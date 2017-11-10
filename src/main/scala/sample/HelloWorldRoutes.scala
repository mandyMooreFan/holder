package sample

import akka.actor.ActorSystem
import akka.http.scaladsl.server.Route
import com.mfoody.akkaboot.ScalaRouteBuilder

import scala.concurrent.ExecutionContext

class HelloWorldRoutes(system: ActorSystem, executionContext: ExecutionContext)
  extends ScalaRouteBuilder(system, executionContext) {

  override def route: Route = get {
    pathPrefix("hellos") {
      completeWithActor {
        "Hello World"
      }
    }
  }

}