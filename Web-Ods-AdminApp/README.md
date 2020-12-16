# Ed-Fi ODS Admin App

Provides docker deployment for [Ed-Fi ODS Admin App v2.1.0](https://techdocs.ed-fi.org/display/ADMIN/).

**NOTE: This image is suitable for production use.**

## Image Links

[1.1.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/Web-Ods-Admin/Dockerfile)

## Image Variants

The only supported image at this time is an Alpine-based implementation.

`edfialliance/ods-admin-app:<version>`

## Supported Environment Variables

```
API_MODE=<mode of api>
LOGS_FOLDER=<path to store the logs file>
POSTGRES_USER=<default postgres database user>
POSTGRES_PASSWORD=<password for default postgres user>
```

## License Information

View [license information](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/LICENSE) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc. from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
