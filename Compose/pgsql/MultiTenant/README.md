# PgSql MultiTenant Configuration Example
This configuration is a basic example of multiple tenant configurations, with one Admin, Security, and ODS database per tenant.

Includes the following web applications:
* Ed-Fi Web API
* Ed-FI ODS Admin Api

See [Ed-Fi Docker Compose Architecture](https://docs.ed-fi.org/reference/docker/ed-fi-docker-compose-architecture) for more information.

## Admin API Settings

* `ENABLE_DATA_STORE_MANAGEMENT` (default: `false`) enables Admin API's Instance Management
  feature, which lets Admin API create and delete ODS databases directly. This compose file
  already wires the per-tenant `Tenants__<tenant>__ConnectionStrings__EdFi_Ods`/`EdFi_Master`
  settings the feature needs. It also requires each tenant's `db-ods-tenantN` to have
  `Ods_Minimal_Template`/`Ods_Populated_Template` Postgres template databases, which
  `ods-template-databases.sh` builds from SQL dump files on first startup - see
  `SQL_BACKUPS_FOLDER` in `.env.example` and the example volume mounts in
  `compose-multi-tenant-env.override.yml.example`. Without those files mounted, `db-ods-tenantN`
  starts normally and template creation is skipped.
* `PREVENT_DUPLICATE_APPLICATIONS` (default: `false`) rejects registering a new API
  application/client whose name matches an existing one.
* Swagger UI is enabled by default; set `SWAGGER_DEFAULT_TENANT` (default: `tenant1`) so
  Swagger UI requests include a tenant identifier, since Swagger does not send one
  automatically when MultiTenancy is enabled.
