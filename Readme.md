# Introduction
The Akka Boot project exists to simplify writing the code for production ready Akka HTTP services. However 
Akka Boot does not make any choices about the tools and processes you use to deliver your product. In practice it's a 
huge additional effort to setup everything to build, deploy and operate an application. This project exists to help.

If you choose to use the tools we've integrated, you can be up and running with a modern development, deployment and 
operation in half an hour. If you don't like our choices, you can still use our integrations as examples for how to
integrate your toolchain of choice.

Here's what we provide,

* A monorepo project template using SBT. Develop all your services and UI as projects within a single 
Git repository with an integrated build process managed by SBT. SBT makes it easy (SBT easy...) for you to control the 
extent to which you share common code among your projects.
* Tight integration with Docker. Docker Compose handles local development. Deployed environments run on Docker Swarm. 
* Continuous integration with Circle CI. Cirle CI will build all commits to your project and deploy commits made to the
master and production branches. 
* Consolidated logging to Loggly. VMs, containers and any available AWS logs are routed to Loggly.
* Error reporting by Sentry.io. System, application and AWS errors are sent to Sentry.io.
* System monitoring to DataDog. 
* Continuous deployment to development and production environments on AWS. We use Hashicorp Packer and Terraform to 
deliver the following distinct architecture for development and production,
  * A separate VPC.
  * A Docker Swarm to deploy your application services. Separate autoscaling groups for swarm managers and workers both 
  of which are distribute across three availability zones.
  * A bastion server which provides the only SSH access to the VPC. 
  * An ELB which routes HTTPS traffic to your Docker Swarm reverse proxy (Traefik).
  * An otherwise production ready infrastructure. We have done our best to create a secure by default environment 
  and configure AWS with a production ready configuration. 
    * Port 22 on the bastion server and port 443 on the ELB are the only open public ports.
    * Detailing monitoring is enabled for all instances.
    * Configuration changes are logged to Loggly.
    * Security groups tightly control the network traffic within the VPC.
  
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
Many of the following steps require Docker. If you don't already have it, go install Docker now. If you don't want to 
use Docker this project isn't going to be much help.

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
Akka Boot leverages Packer, Terraform and Docker to create turnkey environments in AWS. Out of the box it creates 
development and production swarms in separate VPCs. Each environment includes the following infrastructure, 

* A bastion server with the only publicly available SSH port in the VPC.
*  