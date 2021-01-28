# Ed-Fi Sandbox Databases
Provides docker deployment for ***EdFi_Ods_Sandbox_***, the minimal template **_EdFi_Ods_Minimal_Template_**, and the populated template **_EdFi_Ods_Populated_Template_** databases implementation on PostgreSQL 11. The templates implement the [Ed-Fi Data Standard v3.2.0-c](https://techdocs.ed-fi.org/display/EFDS32/Ed-Fi+Data+Standard+v3.2). The databases are installed when the image is started for the first time with change queries enabled by default. Sandboxes are initially created when the Sandbox Admin application is started.

**NOTE: A vendor for Grandbend is installed by default, and this implementation is not recommended for a production environment.**

## Image Links
[1.0.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/DB-Sandbox/Dockerfile)

## Image Variants
The only supported image at this time is an Alpine-based implementation using [PostgreSQL 11](https://hub.docker.com/_/postgres).

`edfialliance/ods-api-db-sandbox:<version>`

## Supported Environment Variables
``` 
ADMIN_USER=<default admin user for sandbox admin>
ADMIN_PASSWORD=<default password for the sandbox admin user>
MINIMAL_KEY=<minimal template key>
MINIMAL_SECRET=<minimal template secret>
POPULATED_KEY=<populated template key>
POPULATED_SECRET=<populated template secret>
POSTGRES_USER=<default postgres database user>
POSTGRES_PASSWORD=<password for default postgres user>
```

## License Information
View [license information](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/LICENSE) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc. from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within