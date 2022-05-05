# Ed-Fi ODS Admin App

Provides docker deployment for [Ed-Fi ODS Admin App](https://techdocs.ed-fi.org/display/ADMIN/).

**NOTE: This image is suitable for production use.**

## Image Links
- [2.1.1](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.1/Web-Ods-AdminApp/Alpine/mssql/Dockerfile)
- [2.1.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.0/Web-Ods-AdminApp/Alpine/mssql/Dockerfile)
- [2.0.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.0.0/Web-Ods-AdminApp/Alpine/mssql/Dockerfile)

## Image Variants

The only supported image at this time is an Alpine-based implementation.

`edfialliance/ods-admin-app-mssql:<version>`

## Supported Environment Variables

```none
ADMIN_POSTGRES_HOST=<container-resolved name of the PostgreSQL instance containing the Admin and Security databases>
API_MODE=<mode of api>
API_HOSTNAME=<ods api hostname>
ENCRYPTION_KEY=<256 bit key suitable for AES encryption>
LOGS_FOLDER=<path to store the logs file>
ODS_POSTGRES_HOST=<container-resolved name of the PostgreSQL instance containing the ODS database>
SQLSERVER_ODS_DATASOURCE=<DNS or IP Address of the SQL Server Instance, i.e. sql.somedns.org or 10.1.5.9,1433
SQLSERVER_ADMIN_DATASOURCE=<DNS or IP Address of the SQL Server Instance that contains the Admin/Security/Master databases, i.e. sql.somedns.org or 10.1.5.9,1433>
SQLSERVER_USER=<SQL Username with access to SQL Server Ed-Fi databases, edfiadmin>
SQLSERVER_PASSWORD=<SQL Password for the SQLSERVER_USER with access to SQL Server Ed-Fi databases, password123!>
API_INTERNAL_URL=<the ODS / API endpoint for admin app to internally connect>
ADMINAPP_VIRTUAL_NAME=<virtual name for admin app's endpoint>
ADMINAPP_HEALTHCHECK_TEST=<the health check url for admin app>
```

`API_HOSTNAME` value is required for successfully connecting to ODS/API. This should be the full host (server) name for public access to the API, not including protocol (e.g. "https") or path (e.g. "/api"). For example, if running on a virtual machine called `edfi` on network `my-district.edu` then this value would be `API_HOSTNAME=edfi.my-district.edu`.

## License Information

View [license
information](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/LICENSE)
for the software contained in this image.

As with all Docker images, these likely also contain other software which may be
under other licenses (such as Bash, etc. from the base distribution, along with
any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to
ensure that any use of this image complies with any relevant licenses for all
software contained within.
