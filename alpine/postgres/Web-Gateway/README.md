# Ed-Fi Web Gateway
Provides docker deployment for nginx as a proxy for the Ed-Fi ODS/API. 

**NOTE: The current implementation is using routes based on ports as virtual path based routes are not fully functional, and will be addressed with a future version of the ODS/API. This image is suitable for production use.**

## Image Links
[1.0.0](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/Web-Gateway/Dockerfile)

## Image Variants
The only supported image at this time is an Alpine-based implementation using [nginx](https://hub.docker.com/_/nginx).

`edfialliance/ods-api-web-gateway:<version>`

## License Information
View [license information](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/blob/main/LICENSE) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc. from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.