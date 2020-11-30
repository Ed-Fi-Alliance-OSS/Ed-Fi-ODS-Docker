# EdFi ODS Database
Provides docker deployment for **_EdFi_Ods** and the minimal template **_EdFi_Ods_Minimal_Template_** database implementations on PostgreSQL 11 using the unified model version [data model 3.2.c](https://techdocs.ed-fi.org/display/EFDS32/Unifying+Data+Model+-+v3.2+Handbook) for template and installed database. The databases are installed when the image is is started for the first time and change queries is enabled by default.

**Note: This image is suitable for production use in _shared instance_ mode.**

## Image Links
[1.0.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/DB-ODS/Dockerfile)

## Image Variants
The only supported image at this time is an Alpine implementation using [PostgreSQL 11](https://hub.docker.com/_/postgres).

`edfialliance/ods-api-db-ods:<version>`

## Supported Environment Variables
``` 
POSTGRES_USER=<default postgres database user>
POSTGRES_PASSWORD=<password for default postgres user>
```

## License Information
View [license information](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/LICENSE) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.