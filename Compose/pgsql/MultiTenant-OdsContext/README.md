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
* Admin API's Instance Management feature (`ENABLE_DATA_STORE_MANAGEMENT`) is **not** wired
  in this compose file: this topology runs a separate ODS database (and PgBouncer) per school
  year per tenant, so there is no single ODS host per tenant the feature could target.
* Each `db-ods-tenantN-YYYY` container still ships `ods-template-databases.sh`, which can
  pre-build its `Ods_Minimal_Template`/`Ods_Populated_Template` databases from SQL dump files
  (see the `SQL_BACKUPS_FOLDER_TENANT<n>_<year>` examples in
  `compose-multi-tenant-odscontext-env.override.yml.example`), ahead of a future per-context
  Instance Management wiring. Without those files mounted, the containers start normally and
  template creation is skipped.
