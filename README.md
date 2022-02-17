# Ed-Fi-ODS-Docker

This repository hosts the Docker deployment source code for ODS/API. To work with what is offered in this repository, set up your Docker environment by referring to the [Docker Deployment document](https://techdocs.ed-fi.org/display/EDFITOOLS/Docker+Deployment).

### Exposed Ports

The compose files expose the databases outside of the Docker network (through PgBouncer). To disable this, modify the compose file by removing the `ports` key for the databases PgBouncers. For example:

```yaml
pb-ods:
  image: pgbouncer/pgbouncer
  environment:
    DATABASES: "* = host = db-ods port=5432 user=${POSTGRES_USER} password=${POSTGRES_PASSWORD}"
    PGBOUNCER_LISTEN_PORT: "${PGBOUNCER_LISTEN_PORT:-6432}"
  ports:
    - "5402:${PGBOUNCER_LISTEN_PORT:-6432}"
  restart: always
  container_name: ed-fi-pb-ods
  depends_on:
    - db-ods
```

would be changed to:

```yaml
pb-ods:
  image: pgbouncer/pgbouncer
  environment:
    DATABASES: "* = host = db-ods port=5432 user=${POSTGRES_USER} password=${POSTGRES_PASSWORD}"
    PGBOUNCER_LISTEN_PORT: "${PGBOUNCER_LISTEN_PORT:-6432}"
  restart: always
  container_name: ed-fi-pb-ods
  depends_on:
    - db-ods
```

### Supported environment variables
[.env.example](.env.example) file included in the repository lists the supported environment variables.

## PgBouncer
These compose files use [PGBouncer](https://www.pgbouncer.org/) to manage the connection pools for the database as PostgreSQL does not manage connections. Without this management the database runs out of connections and requires a reboot. There are other solutions available or if the implementor would like to remove this dependency the following needs to be changed.

1. Remove and/or comment out the `pb-admin` and `pb-ods*` services from the compose file.
2. Update `admin`, and `api` services and change the database environment variables (`ODS_POSTGRES_HOST`, and `ADMIN_POSTGRES_HOST`) to point to `db-ods` and `db-admin` from `pb-ods` and `pb-admin`.
3. Update the `POSTGRES_PORT` environment variable to point to 5432.
4. If required expose the port on the services `db-admin`, and `db-ods` services. Note these ports should be independent.

## Contributing

The Ed-Fi Alliance welcomes code contributions from the community. For more information, see:

* [Ed-Fi Contribution Guidelines](https://techdocs.ed-fi.org/display/ETKB/Code+Contribution+Guidelines).
* [How to Submit an Issue](https://techdocs.ed-fi.org/display/ETKB/How+To%3A+Submit+an+Issue).
* [How Submit a Feature Request](https://techdocs.ed-fi.org/display/ETKB/How+To%3A+Submit+a+Feature+Request).

## Legal Information

Copyright (c) 2020 Ed-Fi Alliance, LLC and contributors.

Licensed under the [Apache License, Version 2.0](LICENSE) (the "License").

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

See [NOTICES](NOTICES.md) for additional copyright and license notifications.
