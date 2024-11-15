# Ed-Fi Web Gateway
Provides docker deployment for nginx as a proxy for the Ed-Fi ODS/API.

## Image Variants
The only supported image at this time is an Alpine-based implementation using [nginxinc/nginx-unprivileged](https://hub.docker.com/r/nginxinc/nginx-unprivileged).

`edfialliance/ods-api-web-gateway:<version>`

## Supported Environment Variables
```
ODS_VIRTUAL_NAME=<virtual name for the ods endpoint>
ADMIN_API_VIRTUAL_NAME=<virtual name for the admin api>
ADMIN_CONSOLE_VIRTUAL_NAME=<virtual name for the admin console>
KEYCLOAK_VIRTUAL_NAME=<virtual name for the idp Keycloak>
```

## License Information
View [license information](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/LICENSE) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc. from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
