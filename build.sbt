import scala.sys.process._

organization := "com.github.mfoody"

name := "akka-boot-starter"

version := "0.1"

scalaVersion := "2.12.4"

mainClass in assembly := Some("sample.HelloWorldApplication")

val akkaHttpVersion = "10.0.10"

val akkaVersion = "2.5.6"

lazy val root = project.in(file("."))
  .settings(
    libraryDependencies ++= Seq(
      "com.github.mfoody" %% "akka-boot" % "0.3.0",
      "io.sentry" % "sentry-logback" % "1.6.3",
      "org.logback-extensions" % "logback-ext-loggly" % "0.1.2",

      // Test
      "org.scalatest" %% "scalatest" % "3.0.4" % Test,
      "com.typesafe.akka" %% "akka-http-testkit" % akkaHttpVersion % Test,
      "com.typesafe.akka" %% "akka-stream-testkit" % akkaVersion % Test,
      "com.typesafe.akka" %% "akka-testkit" % akkaVersion % Test)
  )

lazy val database = project.in(file("database"))
  .enablePlugins(JooqCodegen)
  .settings(
    libraryDependencies ++= Seq("runtime", "jooq").map { conf =>
      "mysql" % "mysql-connector-java" % "5.1.16" % conf
    },
    jooqVersion := "3.10.1",
    autoJooqLibrary := true,
    jooqGroupId := "org.jooq",
    jooqCodegen := jooqCodegen.dependsOn(flywayMigrate in schema).value,
    jooqCodegenConfigFile := Some(file("jooq-codegen.xml")),
    jooqCodegenStrategy := CodegenStrategy.Always
  )

lazy val schema = project.in(file("database/schema"))
  .settings(
    flywayUrl := "jdbc:mysql://localhost:3306",
    flywayUser := "root",
    flywayPassword := "test",
    flywaySchemas := Seq("baseball_card_game"),
    flywayLocations := Seq("classpath:db/migration"),
    libraryDependencies += "mysql" % "mysql-connector-java" % "5.1.16" % "runtime"
  )

lazy val dockerComposeUp = taskKey[Unit]("Run docker image in development")

dockerComposeUp := {
  assembly.value

  "docker-compose up -d" !
}

lazy val dockerComposeBuild = taskKey[Unit]("Build and update container")

dockerComposeBuild := {
  assembly.value
  "docker-compose up -d --no-deps --build web" !
}