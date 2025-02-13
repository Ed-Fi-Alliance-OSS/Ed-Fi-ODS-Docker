# Getting Started with Docker Containers for Ed-Fi ODS

This guide provides basic instructions for creating and tearing down Docker containers for the Ed-Fi ODS API sandbox installation using the files in this repository. For more detailed information, please refer to the [Docker Deployment document](https://docs.ed-fi.org/reference/docker/) in Tech Docs.

## Prerequisites

Before you begin, make sure you have the following installed:

- **Docker Desktop**: [Install Docker](https://docs.docker.com/get-docker/).
- **PowerShell**: Required to run certain scripts.
- **Bash shell environment**: Required to run the script to generate a self-signed SSL certificate.

## Setting Up the Environment

### Step 1: Clone or Extract the Repository

If you still need to do so, clone the repository or extract its contents.

```
git clone https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker.git
cd Ed-Fi-ODS-Docker
```

### Step 2: Generate an encryption key for the ODS connection strings

The ODS database connection strings are stored in the EdFi_Admin database and encrypted at rest. To support encryption and decryption, a Base64-encoded 256-bit encryption key must be provided via an environmental variable in the next step. To generate a new random encryption key, run the following commands in PowerShell.
```PowerShell
$aes = [System.Security.Cryptography.Aes]::Create()
$aes.KeySize = 256
$aes.GenerateKey()
[System.Convert]::ToBase64String($aes.Key)
```


### Step 3: Set Up Environment Variables File

Create a file named `.env` in the root folder with the contents below. **Replace '<base64-encoded 256-bit key>' with the key generated in Step 2.** Also, ensure the `LOGS_FOLDER` value is a folder on the host system that the Docker engine has permission to wright to

```
ADMIN_USER=admin@example.com
ADMIN_PASSWORD=Admin1
LOGS_FOLDER=c:/tmp/logs
MINIMAL_KEY=minimal
MINIMAL_SECRET=minimalSecret
POPULATED_KEY=populated
POPULATED_SECRET=populatedSecret
POSTGRES_USER=postgres
POSTGRES_PASSWORD=P@ssw0rd
PGBOUNCER_LISTEN_PORT=6432
ODS_VIRTUAL_NAME=api
SANDBOX_ADMIN_VIRTUAL_NAME=admin
TPDM_ENABLED=true
ODS_CONNECTION_STRING_ENCRYPTION_KEY=<base64-encoded 256-bit key>

TAG=7.2
GATEWAY_TAG=v3


# Specify a health check URL for ODS API, Admin App, Sandbox, and Swagger.
# RECOMMENDED: To use the default internal health check endpoints, set:
API_HEALTHCHECK_TEST="curl -f http://localhost/health"
SANDBOX_HEALTHCHECK_TEST="curl -f http://localhost/health"
SWAGGER_HEALTHCHECK_TEST="curl -f http://localhost/health"
```

*For detailed information on configuring environment variables, please refer to the [Docker Deployment document](https://docs.ed-fi.org/reference/docker/) in Tech Docs.*


### Step 4: Generate an SSL certificate

The deployment requires a valid SSL certificate. Run the included `generate-cert.sh` script to create a self-signed SSL certificate. (On a Windows host, you must use Git Bash or WSL). The certificate generation process may take a few minutes to complete.
```sh
./generate-cert.sh
```

### Step 5: Customize the Docker compose configuration (optional)

Under the ' Compose/pgsql ' folder, you will find a `compose-sandbox-env.yml` file. The `sandbox-env-up.ps1` PowerShell helper script uses this file to set up the required services.

A corresponding `compose-sandbox-env.override.yml.example` file is in the same folder. If additional customization is needed, rename this file as `compose-sandbox-env.override.yml` and edit it to include any settings you wish to change, such as port numbers or volume mappings. The PowerShell helper script will automatically apply values defined in the `compose-sandbox-env.override.yml` file when calling Docker Compose, overriding the default settings.

### Step 6: Launch the containers

Execute the `sandbox-env-up.ps1` helper script using PowerShell with administrative privileges:

```sh
./sandbox-env-up.ps1 -Engine PostgreSQL
```

### Step 7: Check Running Containers

Run the following command to verify that the necessary containers are up and running as expected, including services such as the Swagger UI and ODS API.

```sh
docker ps
```

### Step 8: Connect to the ODS Web Interfaces

Once the containers have started and finished initializing, the sandbox ODS web applications can be accessed using the following URLs (NOTE: these URLs may be different if settings were customized in the previous steps):

| Application | URL |
|:----------|:----------|
| Swagger UI | https://localhost |
| Sandbox Admin | https://localhost/admin |    |
| ODS API | https://localhost/api |


### Step 9: Clean Up the Environment

Run the following PowerShell script to remove the Ed-Fi ODS Sandbox Docker containers and volumes.

```sh
./sandbox-env-clean.ps1
```

## Additional Information

- **Creating Custom Compose Files**:

In addition to the example compose files in the `Compose` folder,  the `Compose-Generator` folder in this repository contains a Docker file and a Mustache template for generating customized compose files. Instructions for using this tool can be found in the [Docker Deployment document](https://docs.ed-fi.org/reference/docker/) in Tech Docs.


## Troubleshooting

- **Port Conflicts**: If you encounter port conflicts, ensure no other services are running on the host machine which use port 443, or modify which port the web gateway uses by creating a `compose-sandbox-env.override.yml` file as described in Step 5.
