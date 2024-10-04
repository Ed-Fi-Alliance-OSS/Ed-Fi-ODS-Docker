# Getting Started with Docker Containers for Ed-Fi ODS

This guide provides basic instructions to help you get started by creating the Docker containers for a sandbox Ed-Fi ODS instance using the files in this repository. For detailed information on using this repository, please refer to the [Docker Deployment document](https://techdocs.ed-fi.org/display/EDFITOOLS/Docker+Deployment) in Tech Docs.

## Prerequisites

Before you begin, make sure you have the following installed:

- **Docker**: [Install Docker](https://docs.docker.com/get-docker/).
- **Docker Compose**: [Install Docker Compose](https://docs.docker.com/compose/install/).
- **PowerShell**: Required to run certain scripts.
- **Bash shell environemnt**: Required to run the script to generate a self-signed SSL certificate.

## Setting Up the Environment

### Step 1: Clone or Extract the Repository

If you haven't done so already, clone the repository or extract its contents.

```
git clone https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker.git
cd Ed-Fi-ODS-Docker
```

### Step 2: Generate an encryption key for the ODS connection strings

The ODS database connection strings are stored in the EdFi_Admin database and encrypted at-rest. To support the encryption and decryption of the ODS database connection strings, a Base64 encoded 256-bit encryption key must be provided via an environmental variable in the next step. To generate a new random encryption key, run the following commands in PowerShell.

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

*For detailed information on configuring environment variables, please refer to the [Docker Deployment document](https://techdocs.ed-fi.org/display/EDFITOOLS/Docker+Deployment) in Tech Docs.*


### Step 4: Generate an SSL certificate

The deployment requires a valid SSL certificate. To create a self-signed SSL certificate, run the included `generate-cert.sh` script. (On a Windows host, you will need to use Git Bash or WSL). The certificate generation process may take a few minutes to complete.

```sh
./generate-cert.sh
```

### Step 5: Customize the Docker compose configuration (optional)

You will find a `compose-sandbox-env.yml` file under the `Compose/pgsql` folder. This is used by the `sandbox-env-up.ps1` PowerShell helper script to set up the required services.

There is a corresponding `compose-sandbox-env.override.yml.example` file in the same folder. If additional custimization is needed, rename this file as `compose-sandbox-env.override.yml` and edit it to include any settings which you wish to change, such as port numbers or volume mappings. The PowerShell helper script will automatically apply values defined in `compose-sandbox-env.override.yml` file when calling Docker Compose, overriding the default settings.

## Creating and Running the Containers

### Step 6: Launch the containers

Execute the `sandbox-env-up.ps1` helper script using PowerShell with administrative privileges:

```sh
./sandbox-env-up.ps1 -Engine PostgreSQL
```

### Step 7: Check Running Containers

Verify the necessary containers are up and running as expected, including services such as the Swagger UI and ODS API, by running the following command.

```sh
docker ps
```

### Step 8: Connect to the ODS Web Interfaces

Once the containers have started and finished initializing, the sandbox ODS web applications can be connected to using the following URLs (NOTE: these URLs may be different depending on customizations applied in the previous steps):

| Application | URL |
|:----------|:----------|
| Swagger UI | https://localhost |
| Sandbox Admin | https://localhost/admin |    |
| ODS API | https://localhost/api |


### Step 5: Clean Up the Environment

To remove the Ed-Fi ODS Sandbox Docker containers and volumes, run the following PowerShell script.

```sh
./sandbox-env-clean.ps1
```

## Additional Information

- **Creating Custom Compose Files**:

The example compose files in this repository create ODS instnaces for the years 2022 and 2023. The `Compose-Generator` folder in this repository contains a Docker file along with a mustache template which can be used to generating customized composes files. Instructions for usign this tool can be found in the [Docker Deployment document](https://techdocs.ed-fi.org/display/EDFITOOLS/Docker+Deployment) in Tech Docs.


## Troubleshooting

- **Port Conflicts**: If you encounter port conflicts, ensure there are no other services running on the host machine which use port 443, or modify which port the web gateway uses by creating a `compose-sandbox-env.override.yml` file as described in Step 5.


For more information, consult the included [README.md](./README.md) files in the repository and the [Docker Deployment document](https://techdocs.ed-fi.org/display/EDFITOOLS/Docker+Deployment) in Tech Docs.

