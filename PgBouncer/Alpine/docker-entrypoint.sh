#!/usr/bin/env bash
set -euo pipefail

# Minimal PgBouncer entrypoint: use compose-provided env vars ONLY.
log() { echo "[pgbouncer-entrypoint] $*"; }

CONFIG_DIR="/etc/pgbouncer"
INI_FILE="$CONFIG_DIR/pgbouncer.ini"
USERLIST_FILE="$CONFIG_DIR/userlist.txt"

if [[ "${PGBOUNCER_SET_DATABASE_USER}" == "yes" && -n "${POSTGRESQL_USER}" ]]; then
  if [[ "${PGBOUNCER_SET_DATABASE_PASSWORD}" == "yes" && -n "${POSTGRESQL_PASSWORD}" ]]; then
    # Always write plain password (no md5 hashing)
    printf '"%s" "%s"\n' "${POSTGRESQL_USER}" "${POSTGRESQL_PASSWORD}" > "$USERLIST_FILE"
    log "userlist.txt: plain password written for '${POSTGRESQL_USER}'"
  else
    printf '"%s" ""\n' "${POSTGRESQL_USER}" > "$USERLIST_FILE"
    log "userlist.txt: blank password for '${POSTGRESQL_USER}'"
  fi
else
  : > "$USERLIST_FILE"
  [[ "${PGBOUNCER_SET_DATABASE_USER}" == "yes" ]] && log "userlist.txt empty (no POSTGRESQL_USER)" || log "userlist.txt empty (PGBOUNCER_SET_DATABASE_USER!=yes)"
fi

# If PGBOUNCER_DATABASE is '*' we map wildcard to TARGET_HOST; else we pass the specific name.
DB_MAPPING="* = host=${POSTGRESQL_HOST} port=${POSTGRESQL_PORT}"
if [[ "${PGBOUNCER_DATABASE}" != "*" ]]; then
  DB_MAPPING="${PGBOUNCER_DATABASE} = host=${POSTGRESQL_HOST} port=${POSTGRESQL_PORT}"
fi

cat > "$INI_FILE" <<EOF
[databases]
${DB_MAPPING}

[pgbouncer]
listen_addr = 0.0.0.0
listen_port = ${PGBOUNCER_PORT}
; Pool settings (tune as needed)
max_client_conn = ${MAX_CLIENT_CONN:-1000}
default_pool_size = ${DEFAULT_POOL_SIZE:-20}
reserve_pool_size = ${RESERVE_POOL_SIZE:-5}
reserve_pool_timeout = ${RESERVE_POOL_TIMEOUT:-5}
pool_mode = ${POOL_MODE:-session}
; Auth settings
auth_type = plain
auth_file = ${USERLIST_FILE}
; Logging
logfile = /var/log/pgbouncer/pgbouncer.log
log_connections = ${LOG_CONNECTIONS:-0}
log_disconnections = ${LOG_DISCONNECTIONS:-0}
log_pooler_errors = ${LOG_POOLER_ERRORS:-1}
; Timeouts
server_reset_query = ${SERVER_RESET_QUERY:-DISCARD ALL}
query_timeout = ${QUERY_TIMEOUT:-0}
server_idle_timeout = ${SERVER_IDLE_TIMEOUT:-0}
; TLS disabled by default (add custom logic if needed)
ignore_startup_parameters = ${IGNORE_STARTUP_PARAMETERS:-extra_float_digits}
EOF

if [[ -z "${PGBOUNCER_EXTRA_FLAGS}" ]]; then
  exec "$@"
else
  log "Starting pgbouncer with extra flags: ${PGBOUNCER_EXTRA_FLAGS}"
  read -r -a extra_flags <<<"${PGBOUNCER_EXTRA_FLAGS}"
  exec pgbouncer "${extra_flags[@]}" "$INI_FILE"
fi
