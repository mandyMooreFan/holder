# Introduction
The Akka Boot project exists to simplify writing the code for production ready Akka HTTP services. However 
Akka Boot focuses solely on the code you write and does not make any choices about the tools and processes you use to 
deliver your product. In practice it's a huge additional effort to setup everything to build, deploy and operate an 
application. This sister project exists to help.

If you choose to use the tools we've integrated, you can be up and running with a modern development, deployment and 
operation in half an hour. If you don't like our choices, you can still use our integrations as examples for how to
integrate your toolchain of choice.

Here's what we provide,

* A monorepo project template using SBT. Develop all your services and UI as projects within a single 
Git repository with an integrated build process managed by SBT. SBT makes it easy (SBT easy...) for you to control the 
extent to which you share common code among your projects.
* Tight integration with Docker. Docker is used throughout the project to avoid dealing with installs. Docker Swarm is
also used to run your application locally and on AWS. 
* Continuous integration with Circle CI. Cirle CI will build all commits to your project and deploy commits made to the
master and production branches. 
* Consolidated logging to Loggly. VMs, containers and any available AWS logs are routed to Loggly.
* Error reporting by Sentry.io. System, application and AWS errors are sent to Sentry.io.
* System monitoring to DataDog. 
* Continuous deployment to development and production environments on AWS. We use Hashicorp Packer and Terraform to 
deliver the following distinct environments for development and production,
  * A separate VPC.
  * A Docker Swarm to deploy your application services. Separate autoscaling groups for swarm managers and workers both 
  of which are distributed across three availability zones.
  * A bastion server which provides the only SSH access to the VPC. 
  * An ELB which routes HTTPS traffic to your Docker Swarm reverse proxy (Traefik).
  * An otherwise production ready infrastructure. We have done our best to create a secure by default environment 
  and setup AWS with a production ready configuration. 
    * Port 22 on the bastion server and port 443 on the ELB are the only open public ports.
    * End to end encryption of all communication.
    * Detailed monitoring is enabled for all instances.
    * Configuration changes are logged to Loggly.
    * Security groups tightly control the network traffic within the VPC.
  
# Getting Started

## Setup
It will take about 30 minutes to run through the following steps.
1. [Clone the Project](#clone-the-project)
2. [Continuous Integration with Circle CI](#continuous-integration-with-circle-ci)
3. [UI Development](#ui-development)
4. [Error Monitoring with Sentry.io](#error-monitoring-with-sentry.io)
5. [Log Aggregation with Loggly](#log-aggregation-with-loggly)
6. [System Monitoring with Datadog](#system-monitoring-with-datadog)
7. [Continuous Deployment with AWS](#continuous-deployment-to-aws)

## Development and Deployment
* [Developing and Deploying Locally](#developing-locally)
* [Deploying to AWS](#deploying-to-aws)

## Clone the Project
To get started clone this project

```bash
> git clone https://github.com/mfoody/akka-boot-starter my-project
```

## Docker
Just about everything that follows requires Docker. If you don't already have it, go install Docker now. If you don't 
want to use Docker this project isn't going to be much help.

1. Install Docker

https://store.docker.com/editions/community/docker-ce-desktop-mac
https://store.docker.com/editions/community/docker-ce-desktop-windows

2. Create a Docker Hub account.

https://hub.docker.com/

3. Login to Docker Hub

```bash
> docker login 
```

4. Give it a test run

```bash
> docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://cloud.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/
```

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
Akka Boot Starter integrates with Loggly to provide log aggregation. To enable the integration you must have a Loggly 
account and an active Loggly source key. To create your Loggly account, go to 
[Sign-Up for Loggly](https://www.loggly.com/signup/).

## System Monitoring with Datadog


## Continuous Deployment to AWS
Akka Boot Starter leverages Packer, Terraform and Docker to create turnkey environments in AWS. To enable AWS 
integration you must have an AWS account and IAM credentials with administrative authority. Perform the following
steps to get started with AWS,

1. 

# Developing Locally
Perform the following steps to develop and deploy a new feature on your development machine,

1. Create a feature branch

```bash
> git checkout my-new-feature
```

2. Write some code. If you've just cloned the repository you can edit the HelloWorldRoutes.scala file for the purpose
of this tutorial. We'll add a new route.

```scala
  override def route: Route = get {
    pathPrefix("hellos") {
      parameter("fail".?) { fail =>
        completeWithActor {
          if (fail.isDefined) {
            throw new Exception("Something bad always happened")
          } else {
            "Hello Worlds"
          }
        }
      }
    } ~ 
    pathPrefix("goodbyes") {
      completeWithActor {
        "Goodbye"
      }
    }
  }
```

3. Write some tests (maybe you like to do this first). We'll edit HelloWorldRoutesTest.scala.

```scala
  "GET /goodbyes" should {
    "return Goodbye" in {
      Get("/goodbyes") ~> route ~> check {
        responseAs[String] should ===("""Goodbye""")
      }
    }
  }
```

4. Run your test (in your IDE or SBT).

```bash
> sbt test
```

5. Assuming everything worked deploy your code to your local Docker Swarm. The following script will create a local
Swarm if one doesn't exist.

In docker-compose.yml change the "image:"(Line 41) to a Docker Hub Repository you have created. 
```
  web:
    build: .
    image: {dockerUserName}/{repoName}:latest
    environment:
      environment: development
    networks:

```

Make sure you have a HyperV Virtual Network Switch by the name of "akka-boot".  You can check this by using the
following commands in windows Powershell.

```
Get-NetAdaptor -Name "vEthernet (akka-boot)"
```

If this returns an error it means you need to run the follow command to create it:

```
New-VMSwitch -name akka-boot  -NetAdapterName Ethernet
```

If you're using Windows

```bash
> sh bin\deploy_application.sh local
```

If you're using Linux

```bash
>./bin/deploy_application local
```

Success should look something like this (assuming you have to create a new swarm).

```bash
> sh bin\deploy_application.sh local
Windows git bash detected                                                                                                                                                                                                                 
Deploying to local environment                                                                                                                                                                                                            
Checking for existing swarm                                                                                                                                                                                                               
Host does not exist: "manager"                                                                                                                                                                                                            
bin\deploy_application.sh: line 41: [: Running: unary operator expected                                                                                                                                                                   
Existing swarm not found                                                                                                                                                                                                                  
Creating new swarm                                                                                                                                                                                                                        
Running pre-create checks...                                                                                                                                                                                                              
Creating machine...                                                                                                                                                                                                                       
(manager) Copying C:\Users\wmfoo\.docker\machine\cache\boot2docker.iso to C:\Users\wmfoo\.docker\machine\machines\manager\boot2docker.iso...                                                                                              
(manager) Creating SSH key...                                                                                                                                                                                                             
(manager) Creating VM...                                                                                                                                                                                                                  
(manager) Using switch "myswitch"                                                                                                                                                                                                         
(manager) Creating VHD                                                                                                                                                                                                                    
(manager) Starting VM...                                                                                                                                                                                                                  
(manager) Waiting for host to start...                                                                                                                                                                                                    
Waiting for machine to be running, this may take a few minutes...                                                                                                                                                                         
Detecting operating system of created instance...                                                                                                                                                                                         
Waiting for SSH to be available...                                                                                                                                                                                                        
Detecting the provisioner...                                                                                                                                                                                                              
Provisioning with boot2docker...                                                                                                                                                                                                          
Copying certs to the local machine directory...                                                                                                                                                                                           
Copying certs to the remote machine...                                                                                                                                                                                                    
Setting Docker configuration on the remote daemon...                                                                                                                                                                                      
Checking connection to Docker...                                                                                                                                                                                                          
Docker is up and running!                                                                                                                                                                                                                 
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe env manager                                                           
Running pre-create checks...                                                                                                                                                                                                              
Creating machine...                                                                                                                                                                                                                       
(worker1) Copying C:\Users\wmfoo\.docker\machine\cache\boot2docker.iso to C:\Users\wmfoo\.docker\machine\machines\worker1\boot2docker.iso...                                                                                              
(worker1) Creating SSH key...                                                                                                                                                                                                             
(worker1) Creating VM...                                                                                                                                                                                                                  
(worker1) Using switch "myswitch"                                                                                                                                                                                                         
(worker1) Creating VHD                                                                                                                                                                                                                    
(worker1) Starting VM...                                                                                                                                                                                                                  
(worker1) Waiting for host to start...                                                                                                                                                                                                    
Waiting for machine to be running, this may take a few minutes...                                                                                                                                                                         
Detecting operating system of created instance...                                                                                                                                                                                         
Waiting for SSH to be available...                                                                                                                                                                                                        
Detecting the provisioner...                                                                                                                                                                                                              
Provisioning with boot2docker...                                                                                                                                                                                                          
Copying certs to the local machine directory...                                                                                                                                                                                           
Copying certs to the remote machine...                                                                                                                                                                                                    
Setting Docker configuration on the remote daemon...                                                                                                                                                                                      
Checking connection to Docker...                                                                                                                                                                                                          
Docker is up and running!                                                                                                                                                                                                                 
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe env worker1                                                           
Running pre-create checks...                                                                                                                                                                                                              
Creating machine...                                                                                                                                                                                                                       
(worker2) Copying C:\Users\wmfoo\.docker\machine\cache\boot2docker.iso to C:\Users\wmfoo\.docker\machine\machines\worker2\boot2docker.iso...                                                                                              
(worker2) Creating SSH key...                                                                                                                                                                                                             
(worker2) Creating VM...                                                                                                                                                                                                                  
(worker2) Using switch "myswitch"                                                                                                                                                                                                         
(worker2) Creating VHD                                                                                                                                                                                                                    
(worker2) Starting VM...                                                                                                                                                                                                                  
(worker2) Waiting for host to start...                                                                                                                                                                                                    
Waiting for machine to be running, this may take a few minutes...                                                                                                                                                                         
Detecting operating system of created instance...                                                                                                                                                                                         
Waiting for SSH to be available...                                                                                                                                                                                                        
Detecting the provisioner...                                                                                                                                                                                                              
Provisioning with boot2docker...                                                                                                                                                                                                          
Copying certs to the local machine directory...                                                                                                                                                                                           
Copying certs to the remote machine...                                                                                                                                                                                                    
Setting Docker configuration on the remote daemon...                                                                                                                                                                                      
Checking connection to Docker...                                                                                                                                                                                                          
Docker is up and running!                                                                                                                                                                                                                 
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe env worker2                                                           
Swarm initialized: current node (p2mlvu1gw87cf1sbut740gzmz) is now a manager.                                                                                                                                                             
                                                                                                                                                                                                                                          
To add a worker to this swarm, run the following command:                                                                                                                                                                                 
                                                                                                                                                                                                                                          
    docker swarm join --token SWMTKN-1-65ezag1t3mtu4tz6o2mz4qyp1e413mhpcs80vu1upm605zbwf7-aw5pu6nk1fwdrozo163jpyq72 192.168.8.115:2377                                                                                                    
                                                                                                                                                                                                                                          
To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.                                                                                                                                        
                                                                                                                                                                                                                                          
This node joined a swarm as a worker.                                                                                                                                                                                                     
This node joined a swarm as a worker.                                                                                                                                                                                                     
Docker Swarm created                                                                                                                                                                                                                      
NAME      ACTIVE   DRIVER   STATE     URL                        SWARM   DOCKER        ERRORS                                                                                                                                             
manager   -        hyperv   Running   tcp://192.168.8.115:2376           v17.11.0-ce                                                                                                                                                      
worker1   -        hyperv   Running   tcp://192.168.8.116:2376           v17.11.0-ce                                                                                                                                                      
worker2   -        hyperv   Running   tcp://192.168.8.118:2376           v17.11.0-ce                                                                                                                                                      
Building updated images                                                                                                                                                                                                                   
WARNING: Some services (loggly, traefik, web, whoami, whoareyou) use the 'deploy' key, which will be ignored. Compose does not support 'deploy' configuration - use `docker stack deploy` to deploy to a swarm.                           
whoareyou uses an image, skipping                                                                                                                                                                                                         
traefik uses an image, skipping                                                                                                                                                                                                           
whoami uses an image, skipping                                                                                                                                                                                                            
loggly uses an image, skipping                                                                                                                                                                                                            
Building web                                                                                                                                                                                                                              
Step 1/8 : FROM openjdk:8-jre-alpine                                                                                                                                                                                                      
 ---> e2f6fe2dacef                                                                                                                                                                                                                        
Step 2/8 : COPY ./docker/* ./                                                                                                                                                                                                             
 ---> Using cache                                                                                                                                                                                                                         
 ---> c39a67acc1c2                                                                                                                                                                                                                        
Step 3/8 : COPY target/scala-2.12/akka-boot-starter-assembly-0.1.jar akka-boot-starter.jar                                                                                                                                                
 ---> Using cache                                                                                                                                                                                                                         
 ---> 87d6dccd5c2a                                                                                                                                                                                                                        
Step 4/8 : EXPOSE 80                                                                                                                                                                                                                      
 ---> Using cache                                                                                                                                                                                                                         
 ---> c08182e09f8a                                                                                                                                                                                                                        
Step 5/8 : EXPOSE 81                                                                                                                                                                                                                      
 ---> Using cache                                                                                                                                                                                                                         
 ---> dcba1d9b7732                                                                                                                                                                                                                        
Step 6/8 : EXPOSE 443                                                                                                                                                                                                                     
 ---> Using cache                                                                                                                                                                                                                         
 ---> 1d7d82f0a6cb                                                                                                                                                                                                                        
Step 7/8 : EXPOSE 444                                                                                                                                                                                                                     
 ---> Using cache                                                                                                                                                                                                                         
 ---> ce3eef9c820e                                                                                                                                                                                                                        
Step 8/8 : CMD java     -agentpath:/libsentry_agent_linux-x86_64.so     -jar akka-boot-starter.jar $environment.conf                                                                                                                      
 ---> Using cache                                                                                                                                                                                                                         
 ---> 1e51045d04d6                                                                                                                                                                                                                        
Successfully built 1e51045d04d6                                                                                                                                                                                                           
Successfully tagged wmfoody/akka-boot:latest                                                                                                                                                                                              
WARNING: Some services (loggly, traefik, web, whoami, whoareyou) use the 'deploy' key, which will be ignored. Compose does not support 'deploy' configuration - use `docker stack deploy` to deploy to a swarm.                           
Pushing web (wmfoody/akka-boot:latest)...                                                                                                                                                                                                 
The push refers to a repository [docker.io/wmfoody/akka-boot]                                                                                                                                                                             
32eaaf5d0b3f: Layer already exists                                                                                                                                                                                                        
0acece9466c7: Layer already exists                                                                                                                                                                                                        
762429e05518: Layer already exists                                                                                                                                                                                                        
2be465c0fdf6: Layer already exists                                                                                                                                                                                                        
5bef08742407: Layer already exists                                                                                                                                                                                                        
latest: digest: sha256:92ac77e3e731279efc53d31c7de7ac7c889f10a184ccceec7b0bada7eb42479d size: 1368                                                                                                                                        
Deploying akka-boot-starter to Docker Swarm                                                                                                                                                                                               
docker-compose.yml                                                                                                                                                                                          100% 1709   216.6KB/s   00:00 
Ignoring unsupported options: build                                                                                                                                                                                                       
                                                                                                                                                                                                                                          
Creating network akka-boot-starter_traefik                                                                                                                                                                                                
Creating service akka-boot-starter_web                                                                                                                                                                                                    
Creating service akka-boot-starter_whoami                                                                                                                                                                                                 
Creating service akka-boot-starter_whoareyou                                                                                                                                                                                              
Creating service akka-boot-starter_traefik                                                                                                                                                                                                
Creating service akka-boot-starter_loggly                                                                                                                                                                                                 
                                                                                                                                                                                                                                          
****************************************                                                                                                                                                                                                  
akka-boot-starter deployment is complete                                                                                                                                                                                                  
akka-boot-starter deployed to following instances                                                                                                                                                                                         
                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                          
NAME      ACTIVE   DRIVER   STATE     URL                        SWARM   DOCKER        ERRORS                                                                                                                                             
manager   -        hyperv   Running   tcp://192.168.8.115:2376           v17.11.0-ce                                                                                                                                                      
worker1   -        hyperv   Running   tcp://192.168.8.116:2376           v17.11.0-ce                                                                                                                                                      
worker2   -        hyperv   Running   tcp://192.168.8.118:2376           v17.11.0-ce                                                                                                                                                      
                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                          
ID                  NAME                          MODE                REPLICAS            IMAGE                               PORTS                                                                                                       
b4199cuoocws        akka-boot-starter_loggly      global              0/3                 sendgridlabs/loggly-docker:latest                                                                                                               
o2btxu03yu3h        akka-boot-starter_traefik     replicated          0/1                 traefik:latest                      *:80->80/tcp,*:8080->8080/tcp                                                                               
eqe76enwhc10        akka-boot-starter_web         global              0/3                 wmfoody/akka-boot:latest                                                                                                                        
63j4a4uunxf1        akka-boot-starter_whoami      replicated          1/1                 emilevauge/whoami:latest                                                                                                                        
v0aulom6aam7        akka-boot-starter_whoareyou   replicated          1/1                 emilevauge/whoami:latest                                                                                                                        
```

In this case the services weren't all up when the command finished. To check their status again,

```bash
> docker-machine ssh manager "docker service ls"
ID                  NAME                          MODE                REPLICAS            IMAGE                               PORTS
b4199cuoocws        akka-boot-starter_loggly      global              3/3                 sendgridlabs/loggly-docker:latest
o2btxu03yu3h        akka-boot-starter_traefik     replicated          1/1                 traefik:latest                      *:80->80/tcp,*:8080->8080/tcp
eqe76enwhc10        akka-boot-starter_web         global              3/3                 wmfoody/akka-boot:latest
63j4a4uunxf1        akka-boot-starter_whoami      replicated          1/1                 emilevauge/whoami:latest
v0aulom6aam7        akka-boot-starter_whoareyou   replicated          1/1                 emilevauge/whoami:latest
```

Success! 

6. Access the application using the IP addresses of the instances. Because we're using Traefik as a reverse proxy
you should be able to access any service on any of the nodes on port 80 or 443. 

```bash
> curl 192.168.8.115/whoami
  Hostname: 6c8137f8e623
  IP: 127.0.0.1
  IP: 10.0.0.9
  IP: 10.0.0.10
  IP: 172.18.0.4
  GET /whoami HTTP/1.1
  Host: 192.168.8.115
  User-Agent: curl/7.51.0
  Accept: */*
  Accept-Encoding: gzip
  X-Forwarded-For: 10.255.0.2
  X-Forwarded-Host: 192.168.8.115
  X-Forwarded-Port: 80
  X-Forwarded-Proto: http
  X-Forwarded-Server: d760d85f0899
  X-Real-Ip: 10.255.0.2
  
> curl 192.168.8.116/whoareyou
  Hostname: 56b5a4773b63
  IP: 127.0.0.1
  IP: 10.0.0.11
  IP: 10.0.0.12
  IP: 172.18.0.4
  GET /whoareyou HTTP/1.1
  Host: 192.168.8.116
  User-Agent: curl/7.51.0
  Accept: */*
  Accept-Encoding: gzip
  X-Forwarded-For: 10.255.0.3
  X-Forwarded-Host: 192.168.8.116
  X-Forwarded-Port: 80
  X-Forwarded-Proto: http
  X-Forwarded-Server: d760d85f0899
  X-Real-Ip: 10.255.0.3  

> curl 192.168.8.115/yo/hellos
  "Hello Worlds"
  
> curl 192.168.8.116/yo/goodbyes
  "Goodbye"
```
 
# Deploying to AWS