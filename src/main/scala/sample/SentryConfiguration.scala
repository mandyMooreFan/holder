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
    SentryConfiguration(dsn, sampleRate, environment, servername, async)
  }

}

case class SentryConfiguration(baseDsn: String, sampleRate: Double, environment: String, servername: String,
                               async: Boolean) {

  def dsn: String = {
    s"$baseDsn?sample.rate=$sampleRate&environment=$environment&servername=$servername&async=$async"
  }

}