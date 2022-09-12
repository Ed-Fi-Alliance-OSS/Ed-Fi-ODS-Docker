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

### PGBouncer logging
By default, PgBouncer logs the configuration file which contains sensitive information such as the host database username and password.  
This functionality can be disabled by applying the QUIET flag. The latest version of .env.example has the configuration variable ```PGBOUNCER_QUIET="true"``` which will suppress this
messaging.  However, older .env files that do not supply the PGBOUNCER\_QUIET configuration variable are still at risk of exposing this sensitive information in logs.

### Connection Pooling Options
These compose files use [PGBouncer](https://www.pgbouncer.org/) to provide a _server-side_ connection pooling solution for PostgreSQL. Without such connection management the database server will likely run out of connections and require a restart. While there are alternatives to PGBouncer for server-side connection pooling, another approach is to use the _client-side_ connection pooling provided by the npgsql ADO.NET Data Provider. However, before using client-side pooling, there are some important considerations.

Client-side pooling with npgsql is based on the connection string (see [Npgsql Connection Pool Explained](https://fxjr.blogspot.com/2010/04/npgsql-connection-pool-explained.html)). The pool can be [configured in the connection string](https://www.npgsql.org/doc/connection-string-parameters.html?q=pooling#pooling) with a minimum (_default=0_) and maximum (_default=100_) pool size. When a connection is requested from the client-side pool the first time, the pool will be initialized with the configured minimum number of connections (_default=0_). After that, the pool will continue to increase in size (as needed) up to the configured maximum (_default=100_). Additionally, the pool will release an idle connection after a period of inactivity (_default=300s_).

One of the challenges here is that by default there is a connection limit of 100 in PostgreSQL. So when configuring client-side pools, the nature of the deployment environment will greatly influence what an appropriate configuration would be to avoid connection failures by exceeding the total connection limit of 100. The Admin App and API processes/containers would each have a minimum of 3 connection pools (for EdFi_Admin, EdFi_Security and the EdFi_Ods). In a year-specific deployment, the number of distinct ODS connection strings (and pools) grows for each school year. In a district-specific or instance-based deployment the number of pools could get to be quite large. Factor in additional containers for high availability and/or scale out, and the total number of client connection pools increases further. As a result, client-side pooling may be untenable for all but the simplest of deployments.

However, to remove PGBouncer as a dependency and configure client-side connection pooling instead, make the following changes:

1. Remove and/or comment out the `pb-admin` and `pb-ods*` services from the compose file.
2. Update `admin`, and `api` services and change the database environment variables (`ODS_POSTGRES_HOST`, and `ADMIN_POSTGRES_HOST`) to point to `db-ods` and `db-admin` from `pb-ods` and `pb-admin`.
3. Update the `POSTGRES_PORT` environment variable to point to 5432.
4. If required expose the port on the services `db-admin`, and `db-ods` services. Note these ports should be independent.
5. Apply connection string settings for [client-side connection pooling](https://www.npgsql.org/doc/connection-string-parameters.html?q=pooling#pooling) in the _appsettings.template.json_ files for the applicable containers.

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
