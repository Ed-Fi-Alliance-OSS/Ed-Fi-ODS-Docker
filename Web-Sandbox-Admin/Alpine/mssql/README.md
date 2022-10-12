# Ed-Fi Web Sandbox Admin
Provides docker deployment for Sandbox Admin tool.

**NOTE: This image is not recommended for production use.**

## Image Links
- [2.2.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.2.0/Web-Sandbox-Admin/Alpine/mssql/Dockerfile)
- [2.1.4](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.4/Web-Sandbox-Admin/Alpine/mssql/Dockerfile)
- [2.1.3](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.3/Web-Sandbox-Admin/Alpine/mssql/Dockerfile)
- [2.1.2](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.2/Web-Sandbox-Admin/Alpine/mssql/Dockerfile)
- [2.1.1](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.1/Web-Sandbox-Admin/Alpine/mssql/Dockerfile)
- [2.1.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.1.0/Web-Sandbox-Admin/Alpine/mssql/Dockerfile)
- [2.0.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/v2.0.0/Web-Sandbox-Admin/Alpine/mssql/Dockerfile)

## Image Variants
The only supported image at this time is an Alpine-based implementation.

`edfialliance/ods-api-web-sandbox-admin-mssql:<version>`

## Supported Environment Variables
```
LOGS_FOLDER=<path to store the log files>
SQLSERVER_ODS_DATASOURCE=<DNS or IP Address of the SQL Server Instance, i.e. sql.somedns.org or 10.1.5.9,1433
SQLSERVER_ADMIN_DATASOURCE=<DNS or IP Address of the SQL Server Instance that contains the Admin/Security/Master databases, i.e. sql.somedns.org or 10.1.5.9,1433>
SQLSERVER_USER=<SQL Username with access to SQL Server Ed-Fi databases, edfiadmin>
SQLSERVER_PASSWORD=<SQL Password for the SQLSERVER_USER with access to SQL Server Ed-Fi databases, password123!>
ADMIN_USER=<default admin user for sandbox admin>
ADMIN_PASSWORD=<default password for the sandbox admin user>
MINIMAL_KEY=<minimal template key>
MINIMAL_SECRET=<minimal template secret>
POPULATED_KEY=<populated template key>
POPULATED_SECRET=<populated template secret>
```

## License Information
View [license information](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/LICENSE) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc. from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
