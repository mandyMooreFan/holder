package sample

import com.mfoody.akkaboot.config.Configuration
import com.typesafe.config.Config

class HelloWorldConfiguration(config: Config) extends Configuration(config) {

  val sentry = SentryConfiguration(config.getConfig("sentry"))

}