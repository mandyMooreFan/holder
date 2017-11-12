# Introduction
The Akka Boot project exists to simplify creating production ready HTTP services using Akka HTTP. However Akka Boot
does not make any choices about the tools and processes you use to deliver your product. In practice setting all this 
up can be a significant effort. This project is here to help with this effort.

To do this Akka Boot Starter makes choices about the tools you need to deploy and operate your application. If you 
choose to use the tools we've integrated, you can be up and running with a modern development, deployment and operation 
in half an hour. If you don't like our choices, you can still use our integrations as examples for how to
integrate your toolchain of choice.

# Getting Started

1. [Clone the Project](#clone-the-project)
2. [Continuous Integration with Circle CI](#continuous-integration-with-circle-ci)
3. [UI Development](#ui-development)
4. [Error Monitoring with Sentry.io](#error-monitoring-with-sentry.io)
5. [Log Aggregation with Loggly](#log-aggregation-with-loggly)
6. [System Monitoring with Datadog](#system-monitoring-with-datadog)
7. [Continuous Deployment with AWS](#continuous-deployment-to-aws)

## Clone the Project
To get started clone this project

```bash
> git clone https://github.com/mfoody/akka-boot-starter my-project
```

## Docker
Many of the following steps require Docker. If you don't already have it, go install Docker now.

## Continuous Integration with Circle CI

## UI Development 

### With Angular

### With React

## Error Monitoring with Sentry.io
Akka Boot Starter integrates with Sentry.io to provide error alerting. To enable the integration you must have a 
Sentry.io account and configured a project within the application. To create your Sentry.io account, follow the 
instructions at,

[Sentry.io Quickstart](https://docs.sentry.io/quickstart/)

Once you have the DSN from the Sentry.io, update development.conf with the dsn and the packages you would like to 
monitor.

```yaml
{
  sentry {
    dsn = "<FILL ME IN>"
    sampleRate = 0.75
    environment = "development"
    async = true
    packages = "<FILL ME IN>"
  }
}
```

## Log Aggregation with Loggly


## System Monitoring with Datadog


## Continuous Deployment to AWS

