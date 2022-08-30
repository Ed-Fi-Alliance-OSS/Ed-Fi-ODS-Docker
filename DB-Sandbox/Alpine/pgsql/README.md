# Ed-Fi Sandbox Databases
Provides docker deployment for ***EdFi_Ods_Sandbox_\****, the minimal template **_EdFi_Ods_Minimal_Template_**, and the populated template **_EdFi_Ods_Populated_Template_** databases implementation on PostgreSQL 13. The templates implement the Ed-Fi Data Standard. The databases are installed when the image is started for the first time with change queries enabled by default. Sandboxes are initially created when the Sandbox Admin application is started.

**NOTE: A vendor for Grandbend is installed by default, and this implementation is not recommended for a production environment.**

## Image Links
- [2.1.2](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.2/DB-Sandbox/Alpine/pgsql/Dockerfile)
- [2.1.1](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.1/DB-Sandbox/Alpine/pgsql/Dockerfile)
- [2.1.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.0/DB-Sandbox/Alpine/pgsql/Dockerfile)
- [2.0.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.0.0/DB-Sandbox/Alpine/pgsql/Dockerfile)
- [1.1.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v1.1.0/DB-Sandbox/Dockerfile)
- [1.0.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v1.0.0/DB-Sandbox/Dockerfile)

## Image Variants
The only supported image at this time is an Alpine-based implementation using [PostgreSQL 13](https://hub.docker.com/_/postgres).

`edfialliance/ods-api-db-sandbox:<version>`

## Supported Environment Variables
```
POSTGRES_USER=<default PostgreSQL database user>
POSTGRES_PASSWORD=<password for default PostgreSQL user>
TPDM_ENABLED=<true/false include TPDM tables> (OPTIONAL, default: true)
```

## License Information
View [license information](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/LICENSE) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc. from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
