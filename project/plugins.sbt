addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.14.5")

addSbtPlugin("org.flywaydb" % "flyway-sbt" % "4.2.0")
resolvers += "Flyway" at "https://davidmweber.github.io/flyway-sbt.repo"

addSbtPlugin("com.github.kxbmap" % "sbt-jooq" % "0.3.3")