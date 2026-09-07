# PgSql MultiTenant with ODS Context Configuration Example
This configuration shows a basic example of a multi tenant configuration with an explicit data segmentation strategy based on the school year. Deployment has one Admin, Security per tenant, and one ODS per school year. ODS for the school year is selected based on the school year in the API route segment.

Includes the following web applications:
* Ed-Fi Web API
* Ed-FI ODS Admin Api

See [Ed-Fi Docker Compose Architecture](https://docs.ed-fi.org/reference/docker/ed-fi-docker-compose-architecture) for more information.

## Admin API Settings

* `PREVENT_DUPLICATE_APPLICATIONS` (default: `false`) rejects registering a new API
  application/client whose name matches an existing one.
* Swagger UI is enabled by default; set `SWAGGER_DEFAULT_TENANT` (default: `tenant1`) so
  Swagger UI requests include a tenant identifier, since Swagger does not send one
  automatically when MultiTenancy is enabled.
* `ENABLE_DATA_STORE_MANAGEMENT` (default: `false`) enables Admin API's Instance Management
  feature. This topology runs a separate ODS database (and PgBouncer) per school year per
  tenant, but `Tenants__<tenant>__ConnectionStrings__EdFi_Ods`/`EdFi_Master` is a single pair
  per tenant, so each tenant is pointed at its `pb-ods-tenantN-2023` host (the latest year). New
  databases created via the API land on that host only - it cannot provision a new per-year
  host, since a static compose file can't spin up a new container dynamically.
* Each `db-ods-tenantN-YYYY` container ships `ods-template-databases.sh`, which builds its
  `Ods_Minimal_Template`/`Ods_Populated_Template` databases from SQL dump files (see the
  `SQL_BACKUPS_FOLDER_TENANT<n>_<year>` examples in
  `compose-multi-tenant-odscontext-env.override.yml.example`) - required on both
  `db-ods-tenant1-2023` and `db-ods-tenant2-2023` if you enable `ENABLE_DATA_STORE_MANAGEMENT`.
  Without those files mounted, the containers start normally and template creation is skipped.
