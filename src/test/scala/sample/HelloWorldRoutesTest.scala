package sample

import akka.http.scaladsl.testkit.ScalatestRouteTest
import org.scalactic.TypeCheckedTripleEquals
import org.scalatest.{Matchers, WordSpec}

class HelloWorldRoutesTest extends WordSpec with Matchers with ScalatestRouteTest with TypeCheckedTripleEquals {

  val route = new HelloWorldRoutes(system, system.dispatcher).route

  "GET /hellos" should {
    "return Hello World" in {
      Get("/hellos") ~> route ~> check {
        responseAs[String] should ===(""""Hello World"""")
      }
    }
  }

}
