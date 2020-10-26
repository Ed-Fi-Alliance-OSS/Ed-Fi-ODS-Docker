#!/bin/sh
initdb -D /var/lib/postgres/data
pg_ctl -D "/var/lib/postgres/data" -o "-c listen_addresses=''" -w start
source ./db_auth.cfg
psql -d postgres -c "CREATE USER pguser WITH PASSWORD=$(eval echo ${DB_PASSWORD} | base64 --decode);"
psql -v ON_ERROR_STOP=1 -d postgres -c "CREATE DATABASE dockertest OWNER 'pguser';"
pg_ctl -v ON_ERROR_STOP=1 -D "/var/lib/postgres/data" -m fast -w stop
exec "$@"
