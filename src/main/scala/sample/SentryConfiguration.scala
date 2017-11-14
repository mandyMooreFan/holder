package sample

import java.net.InetAddress

import com.typesafe.config.Config

object SentryConfiguration {

  /**
    *
    * @param config
    * @return
    */
  def apply(config: Config): SentryConfiguration = {
    val dsn = config.getString("dsn")
    val sampleRate = config.getDouble("sampleRate")
    val environment = config.getString("environment")
    val servername = InetAddress.getLocalHost.getHostName
    val async = config.getBoolean("async")
    val packages = config.getString("packages")
    SentryConfiguration(dsn, sampleRate, environment, servername, async, packages)
  }

}

case class SentryConfiguration(baseDsn: String, sampleRate: Double, environment: String, servername: String,
                               async: Boolean, packages: String) {

  def dsn: String = {
    s"$baseDsn?sample.rate=$sampleRate&environment=$environment&servername=$servername&async=$async&stacktrace.app.packages=$packages"
  }

}