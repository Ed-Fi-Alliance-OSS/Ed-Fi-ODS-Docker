# Ed-Fi-ODS-Docker
This repository hosts the docker deployment source code for ODS/API

# DOCKER CONCEPTS

Docker is a platform for developers and sysadmins to build, run, and share applications with containers. The use of containers to deploy applications is called containerization. Containers are not new, but their use for easily deploying applications is.

Containerization is increasingly popular because containers are:

 Flexible: Even the most complex applications can be containerized.
 
 Lightweight: Containers leverage and share the host kernel, making them much more efficient in terms of system resources than virtual machines.
 
Portable: You can build locally, deploy to the cloud, and run anywhere.

Loosely coupled: Containers are highly self sufficient and encapsulated, allowing you to replace or upgrade one without disrupting others.

Secure: Containers apply aggressive constraints and isolations to processes without any configuration required on the part of the user.

# Images and containers

Fundamentally, a container is nothing but a running process, with some added encapsulation features applied to it in order to keep it isolated from the host and from other containers. One of the most important aspects of container isolation is that each container interacts with its own private filesystem; this filesystem is provided by a Docker image. An image includes everything needed to run an application - the code or binary, runtimes, dependencies, and any other filesystem objects required


For Setting up your Docker Environment [click here](https://docs.docker.com/get-started/#set-up-your-docker-environment)

## Docker commands

  docker build -t image-name .
  
  docker images
  
  docker run -d --name container name image-name
  
  docker ps 
  
  
# DOCKER COMPOSE



Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a Compose file to configure your application's services. Then, using a single command, you create and start all the services from your configuration.Compose is great for development, testing, and staging environments, as well as CI workflows.
Using Compose we can define application environment with a Dockerfile so it can be reproduced anywhere.Run docker-compose up and Compose starts and runs your entire app.

The Compose file provides a way to document and configure all of the application’s service dependencies (databases, queues, caches, web service APIs, etc). Using the Compose command line tool you can create and start one or more containers for each dependency with a single command (docker-compose up).


## Installation

You can run Compose on macOS, Windows, and 64-bit Linux.

Prerequisites

•Docker Compose relies on Docker Engine for any meaningful work, so make sure you have Docker Engine installed either locally or remote, depending on your setup.

•On desktop systems like Docker for Mac and Windows, Docker Compose is included as part of those desktop installs.

•On Linux systems, first install the Docker for your OS as described on the Get Docker page, then come back here for instructions on installing Compose on Linux systems.

1) Run this command to download the latest version of Docker Compose:$sudocurl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname-s)-$(uname-m)" -o /usr/local/bin/docker-composeUse the latest Compose release number in the download command.The above command is an example, and it may become out-of-date. Please refer below link in case of any issues with installation. https://docs.docker.com/compose/install/
2) Apply executable permissions to the binary:$sudochmod+x /usr/local/bin/docker-compose
3) Test the installation.$docker-compose --version

## What you'll need in your system

DockerCE

Download code from github

Extract the zip file  to your local file system

Run

Open command prompt or dockerwindows  terminal  and navigate to the path where we have docker-compose.yml exists

Run command docker-compose up


## docker-compose commands

Following commands can be used with docker-compose <command> d

Ex: docker-compose up

To get more help about particular command > docker-compose <command> --helpEx: docker-compose up --help


Full documentation is available on Docker's [website](https://docs.docker.com/compose/)

## How to generate self-sign certificate

After completing the following steps, the certificate and key will be in folder Ed-Fi-ODS-Docker/Web-Gateway/ssl

1) Start a WSL session
2) Change directory to the Web-Gateway folder under Ed-Fi-ODS-Docker repository folder
3) Run script generate-cert.sh (i.e. ./generate-cert.sh)