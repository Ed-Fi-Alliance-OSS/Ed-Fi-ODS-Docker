# PgSql SingleTenant with ODS Context Configuration Example
This configuration shows a basic example of explicit data segmentation strategy based on school year, i.e., the school year becomes a required part of the API route segments.

Includes the following web applications:
* Ed-Fi Web API
* Ed-FI ODS Admin Api

See [Ed-Fi Docker Compose Architecture](https://docs.ed-fi.org/reference/docker/ed-fi-docker-compose-architecture) for more information.

## Admin API Settings

* `PREVENT_DUPLICATE_APPLICATIONS` (default: `false`) rejects registering a new API
  application/client whose name matches an existing one.
* Swagger UI is enabled by default (`SwaggerSettings__EnableSwagger: "true"`).
* `ENABLE_DATA_STORE_MANAGEMENT` (default: `false`) enables Admin API's Instance Management
  feature. This topology runs a separate ODS database (and PgBouncer) per school year
  (`pb_ods_2022`, `pb_ods_2023`), but `ConnectionStrings__EdFi_Ods`/`EdFi_Master` is a single
  pair, so it's pointed at `pb_ods_2023` (the latest year). New databases created via the API
  land on that host only - it cannot provision a new per-year host, since a static compose file
  can't spin up a new container dynamically.
* Each `db-ods-YYYY` container ships `ods-template-databases.sh`, which builds its
  `Ods_Minimal_Template`/`Ods_Populated_Template` databases from SQL dump files (see the
  `SQL_BACKUPS_FOLDER_<year>` examples in
  `compose-single-tenant-odscontext-env.override.yml.example`) - required on `db-ods-2023` if
  you enable `ENABLE_DATA_STORE_MANAGEMENT`. Without those files mounted, the containers start
  normally and template creation is skipped.
