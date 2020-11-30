# Ed-Fi-ODS-Docker
This repository hosts the docker deployment source code for ODS/API

For Setting up your Docker Environment refer to [Docker's setup page](https://docs.docker.com/get-started/#set-up-your-docker-environment).

## Docker Compose

Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a Compose file to configure your application's services. Then, using a single command, you create and start all the services from your configuration.Compose is great for development, testing, and staging environments, as well as CI workflows.
Using Compose we can define application environment with a Dockerfile so it can be reproduced anywhere.Run docker-compose up and Compose starts and runs your entire app.

The Compose file provides a way to document and configure all of the application’s service dependencies (databases, queues, caches, web service APIs, etc). Using the Compose command line tool you can create and start one or more containers for each dependency with a single command (docker-compose up).

Full documentation is available on Docker's [website](https://docs.docker.com/compose/)
## Sample Compose Files
Included in this repository are two compose files for running the ODS/API behind a proxy.

### compose-sandbox-env.yml
Provides an implementation of a sandbox environment with the ODS/API, Sandbox Admin, and SwaggerUI behind nginx. The databases are installed on one instance of PostgreSQL 11. 

### compose-shared-instance-env.yml
Provides an implementation of a shared instance environment of the ODS/API behind nginx. The databases _EdFi_Admin_ and _EdFi_Security_ are are installed on one instance of PostgreSQL 11. The database _EdFi_Ods_ and the minimal template are installed in a separate instance of PostgreSQL 11. 

## .env file
Compose supports declaring default environment variables in an environment file named .env placed in the folder where the docker-compose command is executed (current working directory).
For example we can pass env variables like, tag, username, password
Following command can be used with docker-compose
Ex: `docker-compose --env-file .env -f (docker-compose-filename) up`

### Supported environment variables
```
ADMIN_USER=<default admin user for sandbox admin>
ADMIN_PASSWORD=<default password for the sandbox admin user>
API_MODE=<mode to run the ods/api in>
MINIMAL_KEY=<minimal template key>
MINIMAL_SECRET=<minimal template secret>
POPULATED_KEY=<populated template key>
POPULATED_SECRET=<populated template secret>
POSTGRES_USER=<default postgres database user>
POSTGRES_PASSWORD=<password for default postgres user>
```
## How to generate self-sign certificate

After completing the following steps, the certificate and key will be in folder Ed-Fi-ODS-Docker/Web-Gateway/ssl and/or Ed-Fi-ODS-Docker/Web-Gateway-Sandbox/ssl (for sandbox mode).

### Using WSL
* [Enable WSL and installed a Linux distribution from the Microsoft Store](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
* Start a WSL session
* Change directory to the Web-Gateway (Web-Gateway-Sandbox) folder under Ed-Fi-ODS-Docker repository folder
* Convert the script from CRLF to LF endings
* Run script generate-cert.sh (i.e. ./generate-cert.sh)

### Using GitBash
* Start a GitBash Session
* Run the following commands:
  ```
  export MSYS_NO_PATHCONV=1
  cd '{your repo root}/Ed-Fi-ODS-Docker/Web-Gateway'
  ./generate-cert.sh
  ```