# Ed-Fi-ODS-Docker
This repository hosts the Docker deployment source code for ODS/API. To work with what is offered in this repository, set up your Docker environment by referring to [Setup Your Docker Environment](https://docs.docker.com/get-started/#set-up-your-docker-environment).

## Docker Compose
[Docker Compose](https://docs.docker.com/compose/) is a tool for defining and running multi-container Docker applications. This repository includes two compose files for running the ODS/API behind a proxy.

An example how to use run the compose files by running the following command: `docker-compose -f .\compose-sandbox-env.yml up -d`.

### [compose-sandbox-env.yml](compose-sandbox-env.yml)
Provides an implementation of a sandbox environment with the ODS/API, Sandbox Admin, and SwaggerUI behind nginx. The databases are installed on one instance of PostgreSQL 11. 

### [compose-shared-instance-env.yml](compose-shared-instance-env.yml)
Provides an implementation of a shared instance environment of the ODS/API behind nginx. The databases _EdFi_Admin_ and _EdFi_Security_ are are installed on one instance of PostgreSQL 11. The _EdFi_Ods_ database and the minimal template are installed on a separate instance of PostgreSQL 11. 

While these compose files pull down the images from Docker Hub, there are two additional compose files [compose-sandbox-env-build.yml](compose-sandbox-env-build.yml) and [compose-shared-instance-env-build.yml](compose-shared-instance-env-build.yml) included in the repository for working with the `Dockerfile` directly for customizations. 

The repository also includes setup (e.g. [sandbox-env-up.ps1](sandbox-env-up.ps1)) and teardown (e.g. [sandbox-env-clean.ps1](sandbox-env-clean.ps1)) PowerShell scripts that you can refer to see how to use these compose files.

### Exposed Ports
The compose files expose the databases outside of the Docker network. To disable this, modify the compose file by removing the `ports` key for the databases. For example:
```
db:
    build:
      context: ./DB-Sandbox
      dockerfile: Dockerfile
    environment:
      POSTGRES_USER: "${POSTGRES_USER}"
      POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
    ports:
      - "5401:5432"
    volumes:
      -  vol-db-sandbox:/var/lib/postgresql/data
    restart: always
    container_name: ed-fi-db-sandbox
```

would be changed to:

```
db:
    build:
      context: ./DB-Sandbox
      dockerfile: Dockerfile
    environment:
      POSTGRES_USER: "${POSTGRES_USER}"
      POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
    volumes:
      -  vol-db-sandbox:/var/lib/postgresql/data
    restart: always
    container_name: ed-fi-db-sandbox
```

For the ODS/API, Swagger and Sandbox Admin tool, the ports need to be exposed to support the proxy server, as virtual path support is not available at this time. This will be addressed in a future release.

## Logging
The ODS/API and Sandbox Admin have been set up to write logs to a mounted folder within their Docker containers. By setting the environment variable `LOGS_FOLDER` to a path (e.g. c:/tmp/logs for windows hosts or ~/tmp/logs for Linux/MacOs hosts) you can configure the log files to be placed there.

## .env File

Compose supports declaring default [environment variables](https://docs.docker.com/compose/environment-variables/) in an environment file named .env, placed in the folder where the docker-compose command is executed (current working directory). Following command can be used with docker-compose to use an environment file with different name or location.
```
docker-compose --env-file .env.dev -f (docker-compose-filename) up
```

### Supported environment variables
[.env.example](.env.example) file included in the repository lists the supported environment variables:
```
ADMIN_DB=<database server for the admin database>
ADMIN_USER=<default admin user for sandbox admin>
ADMIN_PASSWORD=<default password for the sandbox admin user>
API_MODE=<mode to run the ods/api in>
MINIMAL_KEY=<minimal template key>
MINIMAL_SECRET=<minimal template secret>
LOGS_FOLDER=<path to store the logs file>
ODS_DB=<database server name for the ods database>
POPULATED_KEY=<populated template key>
POPULATED_SECRET=<populated template secret>
POSTGRES_USER=<default postgres database user>
POSTGRES_PASSWORD=<password for default postgres user>
ODS_API_TAG=<version tag of the ODS/API images>

# The following are only needed for Admin App
ODS_ADMIN_APP_TAG=<version tag of the ods-admin-app image>
ENCRYPTION_KEY=<base64-encoded 256-bit key>
```

## Self-Signed Certificate
The deployments require valid SSL certificate to function. A self-signed certificate can be used for a Non-Production environment. This repository includes `generate-cert.sh` script that can be used to generate a self-signed certificate and place it in folder Ed-Fi-ODS-Docker/Web-Gateway/ssl and/or Ed-Fi-ODS-Docker/Web-Gateway-Sandbox/ssl (for sandbox mode) to be used by the running Gateway container. 

If deploying on local Windows host, you will either need GitBash or WSL to run `generate-cert.sh`.
### Using GitBash
* Start a GitBash Session
* Run the following commands:
  ```
  export MSYS_NO_PATHCONV=1
  cd '{your repo root}/Ed-Fi-ODS-Docker/Web-Gateway'
  ./generate-cert.sh
  ```

### Using WSL
* [Enable WSL and installed a Linux distribution from the Microsoft Store](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
* Start a WSL session
* Change directory to the Web-Gateway (Web-Gateway-Sandbox) folder under Ed-Fi-ODS-Docker repository folder
* Convert the script from CRLF to LF endings
* Run script generate-cert.sh (i.e. ./generate-cert.sh)

## Contributing

The Ed-Fi Alliance welcomes code contributions from the community. For more information, see:
* [Ed-Fi Contribution Guidelines](https://techdocs.ed-fi.org/display/ETKB/Code+Contribution+Guidelines).
* [How to Submit an Issue](https://techdocs.ed-fi.org/display/ETKB/How+To%3A+Submit+an+Issue).
* [How Submit a Feature Request](https://techdocs.ed-fi.org/display/ETKB/How+To%3A+Submit+a+Feature+Request).

## Legal Information

Copyright (c) 2020 Ed-Fi Alliance, LLC and contributors.

Licensed under the [Apache License, Version 2.0](LICENSE) (the "License").

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

See [NOTICES](NOTICES.md) for additional copyright and license notifications.