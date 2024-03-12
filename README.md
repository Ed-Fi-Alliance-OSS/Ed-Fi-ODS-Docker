# Ed-Fi-ODS-Docker

This repository hosts the Docker deployment source code for ODS/API. To work with what is offered in this repository, set up your Docker environment by referring to the [Docker Deployment document](https://techdocs.ed-fi.org/display/EDFITOOLS/Docker+Deployment).

## Exposed Ports

The compose files expose the databases outside of the Docker network (through PgBouncer). To disable this, modify the compose file by removing the `ports` key for the databases PgBouncers. For example:

```yaml
pb-ods:
  image: bitnami/pgbouncer
  environment:
      PGBOUNCER_DATABASE: "*"
      PGBOUNCER_PORT: "${PGBOUNCER_LISTEN_PORT:-6432}"
      PGBOUNCER_EXTRA_FLAGS: ${PGBOUNCER_EXTRA_FLAGS}
      POSTGRESQL_USER: "${POSTGRES_USER}"
      POSTGRESQL_PASSWORD: "${POSTGRES_PASSWORD}"
      POSTGRESQL_HOST: db-ods
      PGBOUNCER_SET_DATABASE_USER: "yes"
      PGBOUNCER_SET_DATABASE_PASSWORD: "yes"
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
  image: bitnami/pgbouncer
  environment:
      PGBOUNCER_DATABASE: "*"
      PGBOUNCER_PORT: "${PGBOUNCER_LISTEN_PORT:-6432}"
      PGBOUNCER_EXTRA_FLAGS: ${PGBOUNCER_EXTRA_FLAGS}
      POSTGRESQL_USER: "${POSTGRES_USER}"
      POSTGRESQL_PASSWORD: "${POSTGRES_PASSWORD}"
      POSTGRESQL_HOST: db-ods
      PGBOUNCER_SET_DATABASE_USER: "yes"
      PGBOUNCER_SET_DATABASE_PASSWORD: "yes"
  restart: always
  container_name: ed-fi-pb-ods
  depends_on:
    - db-ods
```

## Supported environment variables

[.env.example](.env.example) file included in the repository lists the supported environment variables.

## Connection Pooling

### PGBouncer security

Variables ```POSTGRESQL_USER: "${POSTGRES_USER}"``` and ```POSTGRESQL_PASSWORD: "${POSTGRES_PASSWORD}"``` set the security to use an auth_file. Connections done through an exposed pgbouncer port will require a valid user and password.
Variables ```PGBOUNCER_SET_DATABASE_USER: "yes"``` and ```PGBOUNCER_SET_DATABASE_PASSWORD: "yes"``` will include the database and password in the connection string, allowing to have access to the databases in the PG server.

### PGBouncer logging

By default, PgBouncer logs the configuration file which contains sensitive information such as the host database username and password.
This functionality can be disabled by applying the QUIET flag. The latest version of .env.example has the configuration variable ```PGBOUNCER_EXTRA_FLAGS="--quiet"``` which will suppress this
messaging.  However, older .env files that do not supply the PGBOUNCER\_QUIET configuration variable are still at risk of exposing this sensitive information in logs.

### Connection Pooling Options

These compose files use [PGBouncer](https://www.pgbouncer.org/) to provide a _server-side_ connection pooling solution for PostgreSQL. Without such connection management the database server will likely run out of connections and require a restart. While there are alternatives to PGBouncer for server-side connection pooling, another approach is to use the _client-side_ connection pooling provided by the npgsql ADO.NET Data Provider. However, before using client-side pooling, there are some important considerations.

Client-side pooling with npgsql is based on the connection string (see [Npgsql Connection Pool Explained](https://fxjr.blogspot.com/2010/04/npgsql-connection-pool-explained.html)). The pool can be [configured in the connection string](https://www.npgsql.org/doc/connection-string-parameters.html?q=pooling#pooling) with a minimum (_default=0_) and maximum (_default=100_) pool size. When a connection is requested from the client-side pool the first time, the pool will be initialized with the configured minimum number of connections (_default=0_). After that, the pool will continue to increase in size (as needed) up to the configured maximum (_default=100_). Additionally, the pool will release an idle connection after a period of inactivity (_default=300s_).

One of the challenges with client-side pooling is that by default there is a connection limit of 100 in PostgreSQL, so when configuring client-side pooling the nature of the deployment environment will greatly influence what an appropriate configuration would be (to avoid connection failures by exceeding the total number of available connections). Consider the following:

* The Admin App and API processes/containers would each have a minimum of 3 connection pools (for the EdFi_Admin, EdFi_Security and the EdFi_Ods databases).
* In a year-specific deployment, the number of distinct ODS connection strings (and pools) grows for each school year.
* In a district-specific or instance-based deployment the number of pools could get to be quite large.
* Factor in additional containers for high availability and/or scale out, and the total number of client connection pools increases further.

As a result, client-side pooling may be untenable for all but the simplest of deployments.

The following environment variables can be used to control client-side pooling with the API, Admin App and Sandbox Admin containers:

| Name                                 | Applies To    | Description                                                                                                    |
| ------------------------------------ | ------------- | -------------------------------------------------------------------------------------------------------------- |
| `NPG_POOLING_ENABLED`                | All           | Enables or disables client-side pooling (*default: false*).                                                    |
| `NPG_API_MAX_POOL_SIZE_ODS`          | API           | The maximum number of connections for each distinct ODS database from each Ed-Fi ODS API container.            |
| `NPG_API_MAX_POOL_SIZE_ADMIN`        | API           | The maximum number of connections for the EdFi_Admin database from each Ed-Fi ODS API container.               |
| `NPG_API_MAX_POOL_SIZE_SECURITY`     | API           | The maximum number of connections for the EdFi_Security database from each Ed-Fi ODS API container.            |
| `NPG_API_MAX_POOL_SIZE_MASTER`       | API           | The maximum number of connections for the 'postgres' default database from each Ed-Fi ODS API container.       |
| `NPG_ADMIN_MAX_POOL_SIZE_ODS`        | Admin App     | The maximum number of connections for each distinct ODS database from each Admin App container.                |
| `NPG_ADMIN_MAX_POOL_SIZE_ADMIN`      | Admin App     | The maximum number of connections for the EdFi_Admin database from each Admin App container.                   |
| `NPG_ADMIN_MAX_POOL_SIZE_SECURITY`   | Admin App     | The maximum number of connections for the EdFi_Security database from each Admin App container.                |
| `NPG_SANDBOX_MAX_POOL_SIZE_ODS`      | Sandbox Admin | The maximum number of connections for each distinct ODS database from each Ed-Fi Sandbox Admin container.      |
| `NPG_SANDBOX_MAX_POOL_SIZE_ADMIN`    | Sandbox Admin | The maximum number of connections for the EdFi_Admin database from each Ed-Fi Sandbox Admin container.         |
| `NPG_SANDBOX_MAX_POOL_SIZE_SECURITY` | Sandbox Admin | The maximum number of connections for the EdFi_Security database from each Ed-Fi Sandbox Admin container.      |
| `NPG_SANDBOX_MAX_POOL_SIZE_MASTER`   | Sandbox Admin | The maximum number of connections for the 'postgres' default database from each Ed-Fi Sandbox Admin container. |

To remove PGBouncer, make the following changes:

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

Copyright (c) 2024 Ed-Fi Alliance, LLC and contributors.

Licensed under the [Apache License, Version 2.0](LICENSE) (the "License").

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

See [NOTICES](NOTICES.md) for additional copyright and license notifications.
