# Ed-Fi ODS Database
Provides docker deployment for **_EdFi_Ods_** and the minimal template **_EdFi_Ods_Minimal_Template_** database implementation of Ed-Fi Data Standard on PostgreSQL 13. The databases are installed when the image is started for the first time.

**Note: This image is suitable for production use in _shared instance_ mode.**

## Image Links
- [2.2.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.2.0/DB-ODS/Alpine/pgsql/Dockerfile)
- [2.1.4](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.4/DB-ODS/Alpine/pgsql/Dockerfile)
- [2.1.3](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.3/DB-ODS/Alpine/pgsql/Dockerfile)
- [2.1.2](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.2/DB-ODS/Alpine/pgsql/Dockerfile)
- [2.1.1](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.1/DB-ODS/Alpine/pgsql/Dockerfile)
- [2.1.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.0/DB-ODS/Alpine/pgsql/Dockerfile)
- [2.0.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.0.0/DB-ODS/Alpine/pgsql/Dockerfile)
- [1.1.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v1.1.0/DB-ODS/Dockerfile)
- [1.0.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v1.0.0/DB-ODS/Dockerfile)

## Image Variants
The only supported image at this time is an Alpine-based implementation using [PostgreSQL 13](https://hub.docker.com/_/postgres).

`edfialliance/ods-api-db-ods:<version>`

## Supported Environment Variables
```
POSTGRES_USER=<default PostgreSQL database user>
POSTGRES_PASSWORD=<password for default PostgreSQL user>
ODS_DB=<name for the edfi database>
TPDM_ENABLED=<true/false include TPDM tables> (OPTIONAL, default: true)
```

## License Information
View [license information](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/LICENSE) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc. from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
