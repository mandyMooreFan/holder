import scala.sys.process._

organization := "com.github.mfoody"

name := "akka-boot-starter"

version := "0.1"

scalaVersion := "2.12.4"

mainClass in assembly := Some("sample.HelloWorldApplication")

val akkaHttpVersion = "10.0.10"

val akkaVersion = "2.5.6"

libraryDependencies ++= Seq(
  "com.github.mfoody" %% "akka-boot" % "0.2-SNAPSHOT",
  "io.sentry" % "sentry-logback" % "1.6.3",

  // Test
  "org.scalatest" %% "scalatest" % "3.0.4" % Test,
  "com.typesafe.akka" %% "akka-http-testkit" % akkaHttpVersion % Test,
  "com.typesafe.akka" %% "akka-stream-testkit" % akkaVersion % Test,
  "com.typesafe.akka" %% "akka-testkit" % akkaVersion % Test)

lazy val docker = taskKey[Unit]("Build docker image")

docker := {
  assembly.value

  "docker build -t akka-boot-starter ."!
}

lazy val dockerRun = taskKey[Unit]("Run docker image in development")

dockerRun := {
  docker.value

  "docker run -d --name akka-boot -e environment=development --link loggly-docker:loggly -p 80:80 81:81 443:443 444:444 -t akka-boot-starter"!
}