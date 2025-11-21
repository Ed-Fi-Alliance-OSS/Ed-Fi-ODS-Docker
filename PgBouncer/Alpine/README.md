# Example PgBouncer Image

This directory defines a PgBouncer image used within Ed-Fi ODS Docker environments. It is **not published** to any public registry and demonstrates a lightweight alternative to 3rd party images.

## Goals

- Use environment variables for compatibility with existing compose files.
- Auto-generate `pgbouncer.ini` and `userlist.txt` on container start.
- Support simple wildcard or explicit database mapping.
- Keep configuration minimal and transparent.

## Supported Environment Variables

| Variable | Purpose | Default |
|----------|---------|---------|
| `PGBOUNCER_PORT` | Port PgBouncer listens on | `6432` |
| `PGBOUNCER_DATABASE` | `*` (wildcard) or specific database name | `*` |
| `PGBOUNCER_EXTRA_FLAGS` | Used to pass --quiet or --verbose flags | (empty) |
| `PGBOUNCER_SET_DATABASE_USER` | If `yes`, include user in `userlist.txt` | `yes` |
| `PGBOUNCER_SET_DATABASE_PASSWORD` | If `yes`, include password in `userlist.txt` | `yes` |
| `POSTGRESQL_USER` | Upstream Postgres username | (required if flags above are `yes`) |
| `POSTGRESQL_PASSWORD` | Upstream Postgres password | (required if flags above are `yes`) |
| `POSTGRESQL_HOST` | Upstream Postgres host | `postgres` |
| `POSTGRESQL_PORT` | Upstream Postgres port | `5432` |
| Pool tuning: `MAX_CLIENT_CONN`, `DEFAULT_POOL_SIZE`, `RESERVE_POOL_SIZE`, `RESERVE_POOL_TIMEOUT`, `POOL_MODE` | Pooler behavior | (sensible defaults) |
| Logging: `LOG_CONNECTIONS`, `LOG_DISCONNECTIONS`, `LOG_POOLER_ERRORS` | Log levels | (0, 0, 1) |
| Timeouts: `SERVER_RESET_QUERY`, `QUERY_TIMEOUT`, `SERVER_IDLE_TIMEOUT` | Connection management | (see script) |
| `IGNORE_STARTUP_PARAMETERS` | Parameters to ignore | `extra_float_digits` |

## Build

```bash
cd PgBouncer/Alpine
docker build -t edfi-internal/pgbouncer:local .
```

## Example Usage (Compose)

```yaml
services:
  pgbouncer:
    image: edfi-internal/pgbouncer:local
    environment:
      PGBOUNCER_PORT: 6432
      PGBOUNCER_DATABASE: "*"
      POSTGRESQL_USER: postgres
      POSTGRESQL_PASSWORD: postgres
      POSTGRESQL_HOST: db
      POSTGRESQL_PORT: 5432
    ports:
      - "6432:6432"
    depends_on:
      db:
        condition: service_healthy
```

## Notes

- TLS is not enabled by default. Extend the entrypoint if needed.
- Plain password authentication is hardcoded to `plain` in the entrypoint. To change this behavior you must modify the entrypoint script and rebuild the image.
