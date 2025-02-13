# Ed-Fi-ODS-Docker

[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/badge)](https://securityscorecards.dev/viewer/?uri=github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker)

This repository provides sample Docker Compose configuration files to demonstrate using Ed-Fi in containers. The Docker files for Ed-Fi applications can be found in the respective application repositories. Basic startup instructions are available in the [Getting Started](docs/GETTING_STARTED.md) document. For detailed information on using this repository, please refer to the [Docker Deployment document](https://docs.ed-fi.org/reference/docker/) in the Tech Docs. Previous versions of this repository also included the Docker files for ODS/API and Admin App. The table below contains links to the docker releases for ODS API v6.2 and older.


|       Ed-Fi ODS / API              |                          Ed-Fi ODS Docker Tag                                                         |
|------------------------------------|-------------------------------------------------------------------------------------------------------|
| Ed-Fi ODS / API Suite3 v6.2        | [Ed-Fi ODS Docker v2.3.5 ](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/releases/tag/v2.3.5)|
| Ed-Fi ODS / API Suite3 v5.4        | [Ed-Fi ODS Docker v2.1.8](https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-Docker/releases/tag/v2.1.8) |

### Exposed Ports

The compose files are not configured to allow the databases to be accessed outside of the Docker network using the PgBouncer containers. However, an example *.override.yml file has been provided for each of the examples. If you need to expose the ports, you can rename the override file by removing the '.example' extension and then run the corresponding *-up.ps1 script.

For example, to expose the ports in the Postgres Sandbox example, you can execute the following commands:

```
PS> Rename-Item -Path ./Compose/pgsql/compose-sandbox-env.override.yml.example -NewName compose-sandbox-env.override.yml
PS> ./single-tenant-env-up.ps1
```

### Supported environment variables
[.env.example](.env.example) file included in the repository lists the supported environment variables.

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
* The API processes/containers would each have a minimum of 3 connection pools (for the EdFi_Admin, EdFi_Security and the EdFi_Ods databases).
* In a SingleTenant deployment, the number of distinct ODS connection strings (and pools) grows for each ODS instance configured.
* In a MultiTenant deployment, admin and security connection strings (and pools) grow for each tenant, and the number of distinct ODS connection strings (and pools) grow for the ODS instances configured for each tenant, resulting in many pools.
* Factor in additional containers for high availability and/or scale out, and the total number of client connection pools increases further.

As a result, client-side pooling may be untenable for all but the simplest of deployments.

The following environment variables can be used to control client-side pooling with the API, and Sandbox Admin containers:

| Name                                 | Applies To    | Description                                                                                                    |
| ------------------------------------ | ------------- | -------------------------------------------------------------------------------------------------------------- |
| `NPG_POOLING_ENABLED`                | All           | Enables or disables client-side pooling (*default: false*).                                                    |
| `NPG_API_MAX_POOL_SIZE_ODS`          | API           | The maximum number of connections for each distinct ODS database from each Ed-Fi ODS API container.            |
| `NPG_API_MAX_POOL_SIZE_ADMIN`        | API           | The maximum number of connections for the EdFi_Admin database from each Ed-Fi ODS API container.               |
| `NPG_API_MAX_POOL_SIZE_SECURITY`     | API           | The maximum number of connections for the EdFi_Security database from each Ed-Fi ODS API container.            |
| `NPG_API_MAX_POOL_SIZE_MASTER`       | API           | The maximum number of connections for the 'postgres' default database from each Ed-Fi ODS API container.       |
| `NPG_SANDBOX_MAX_POOL_SIZE_ODS`      | Sandbox Admin | The maximum number of connections for each distinct ODS database from each Ed-Fi Sandbox Admin container.      |
| `NPG_SANDBOX_MAX_POOL_SIZE_ADMIN`    | Sandbox Admin | The maximum number of connections for the EdFi_Admin database from each Ed-Fi Sandbox Admin container.         |
| `NPG_SANDBOX_MAX_POOL_SIZE_SECURITY` | Sandbox Admin | The maximum number of connections for the EdFi_Security database from each Ed-Fi Sandbox Admin container.      |
| `NPG_SANDBOX_MAX_POOL_SIZE_MASTER`   | Sandbox Admin | The maximum number of connections for the 'postgres' default database from each Ed-Fi Sandbox Admin container. |

To remove PGBouncer, make the following changes:

1. Remove or comment out the `pb-*` services in the compose file.
2. Replace the remaining instances of `pb-*` to `db-*` in the compose file, and if applicable, also in the `bootstrap.sh`, `appsettings.dockertemplate.json` and `*.override.yml` files.
3. Add `POSTGRES_PORT=5432` to your .env and replace all instances of `PGBOUNCER_LISTEN_PORT` and `ODS_PGBOUNCER_PORT` to `POSTGRES_PORT` in the compose file, and if applicable, also in the `bootstrap.sh` and `*.override.yml` files.

## Contributing
The Ed-Fi Alliance welcomes code contributions from the community. For more information, see:

* [Ed-Fi Contribution Guidelines](https://docs.ed-fi.org/community/sdlc/code-contribution-guidelines/).
* [How to get Technical Help or Provide Feedback](https://community.ed-fi.org/s/).

## Legal Information

Copyright (c) 2020 Ed-Fi Alliance, LLC and contributors.

Licensed under the [Apache License, Version 2.0](LICENSE) (the "License").

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

See [NOTICES](NOTICES.md) for additional copyright and license notifications.
