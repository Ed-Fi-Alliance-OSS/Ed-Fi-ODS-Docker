# PgSql SingleTenant Configuration Example
This configuration shows a basic example of a single tenant configuration where a single ODS database serves all data going through the API. While this example has one ODS for demonstration purposes, single tenant deployments can support separate ODS databases per school year and district.

Includes the following web applications:
* Ed-Fi Web API
* Ed-FI ODS Admin Api

See [Ed-Fi Docker Compose Architecture](https://docs.ed-fi.org/reference/docker/ed-fi-docker-compose-architecture) for more information.

## Admin API Settings

* `ENABLE_DATA_STORE_MANAGEMENT` (default: `false`) enables Admin API's Instance Management
  feature, which lets Admin API create and delete ODS databases directly. This compose file
  already wires the `ConnectionStrings__EdFi_Ods`/`EdFi_Master` settings the feature needs.
  It also requires `db-ods` to have `Ods_Minimal_Template`/`Ods_Populated_Template` Postgres
  template databases, which `ods-template-databases.sh` builds from SQL dump files on first
  startup - see `SQL_BACKUPS_FOLDER` in `.env.example` and the example volume mount in
  `compose-single-tenant-env.override.yml.example`. Without those files mounted, `db-ods`
  starts normally and template creation is skipped.
* `PREVENT_DUPLICATE_APPLICATIONS` (default: `false`) rejects registering a new API
  application/client whose name matches an existing one.
* Swagger UI is enabled by default (`SwaggerSettings__EnableSwagger: "true"`).
