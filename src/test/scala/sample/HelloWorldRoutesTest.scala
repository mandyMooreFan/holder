package sample

import akka.actor.ActorSystem
import akka.http.scaladsl.server.Route
import akka.http.scaladsl.testkit.ScalatestRouteTest
import com.mfoody.akkaboot.Application
import com.typesafe.config.ConfigFactory
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class HelloWorldRoutesTest extends WordSpec with Matchers with ScalatestRouteTest with TypeCheckedTripleEquals {

  override protected def createActorSystem(): ActorSystem = {
    ActorSystem("test", Application.defaultConfiguration(ConfigFactory.empty(), production = false))
  }

  val route: Route = new HelloWorldRoutes(system, system.dispatcher).route

  "GET /hellos" should {
    "return Hello World" in {
      Get("/hellos") ~> route ~> check {
        responseAs[String] should ===(""""Hello World"""")
      }
    }
  }

}