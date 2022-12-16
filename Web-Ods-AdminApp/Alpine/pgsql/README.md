# Ed-Fi ODS Admin App

Provides docker deployment for [Ed-Fi ODS Admin App](https://techdocs.ed-fi.org/display/ADMIN/).

**NOTE: This image is suitable for production use.**

## Image Variants

The only supported image at this time is an Alpine-based implementation.

`edfialliance/ods-admin-app:<version>`

## Supported Environment Variables

```none
ADMIN_POSTGRES_HOST=<container-resolved name of the PostgreSQL instance containing the Admin and Security databases>
API_MODE=<mode of api>
API_HOSTNAME=<ods api hostname>
ENCRYPTION_KEY=<256 bit key suitable for AES encryption>
LOGS_FOLDER=<path to store the logs file>
ODS_POSTGRES_HOST=<container-resolved name of the PostgreSQL instance containing the ODS database>
POSTGRES_USER=<default postgres database user>
POSTGRES_PASSWORD=<password for default postgres user>
POSTGRES_PORT=<port that postgres run on> (OPTIONAL, default: 5432)
API_INTERNAL_URL=<the ODS / API endpoint for admin app to internally connect>
ADMINAPP_VIRTUAL_NAME=<virtual name for admin app's endpoint>
ADMINAPP_HEALTHCHECK_TEST=<the health check url for admin app>
ODS_WAIT_POSTGRES_HOSTS=<space-separated list of PostgreSQL hosts that should be reachable before starting admin app (used by multi-server)> (OPTIONAL)
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
