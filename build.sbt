import scala.sys.process._

organization := "com.github.mfoody"

name := "akka-boot-starter"

version := "0.1"

scalaVersion := "2.12.4"

mainClass in assembly := Some("sample.HelloWorldApplication")

val akkaHttpVersion = "10.0.10"

val akkaVersion = "2.5.6"

libraryDependencies ++= Seq(
  "com.github.mfoody" %% "akka-boot" % "0.3.0",
  "io.sentry" % "sentry-logback" % "1.6.3",
  "org.logback-extensions" % "logback-ext-loggly" % "0.1.2",

  // Test
  "org.scalatest" %% "scalatest" % "3.0.4" % Test,
  "com.typesafe.akka" %% "akka-http-testkit" % akkaHttpVersion % Test,
  "com.typesafe.akka" %% "akka-stream-testkit" % akkaVersion % Test,
  "com.typesafe.akka" %% "akka-testkit" % akkaVersion % Test)




lazy val dockerComposeUp = taskKey[Unit]("Run docker image in development")

dockerComposeUp := {
  assembly.value

  "docker-compose up -d"!
}

lazy val dockerComposeBuild = taskKey[Unit]("Build and update container")

dockerComposeBuild := {
  assembly.value

  "docker-compose up -d --no-deps --build web"!
}