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
* Admin API's Instance Management feature (`ENABLE_DATA_STORE_MANAGEMENT`) is **not** wired
  in this compose file: this topology runs a separate ODS database (and PgBouncer) per school
  year, so there is no single ODS host the feature could target.
* Each `db-ods-YYYY` container still ships `ods-template-databases.sh`, which can pre-build its
  `Ods_Minimal_Template`/`Ods_Populated_Template` databases from SQL dump files (see the
  `SQL_BACKUPS_FOLDER_<year>` examples in
  `compose-single-tenant-odscontext-env.override.yml.example`), ahead of a future per-context
  Instance Management wiring. Without those files mounted, the containers start normally and
  template creation is skipped.
