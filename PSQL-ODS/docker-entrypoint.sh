#!/bin/sh
# Before PostgreSQL can function correctly, the database cluster must be initialized:
initdb -D /var/lib/postgres/data
pg_ctl -D "/var/lib/postgres/data" -o "-c listen_addresses=''" -w start
# create a user or role
psql -d postgres -c "CREATE USER pguser WITH PASSWORD 'password@';"
# create database
psql -v ON_ERROR_STOP=1 -d postgres -c "CREATE DATABASE dockertest OWNER 'pguser';"
# stop internal postgres server
pg_ctl -v ON_ERROR_STOP=1 -D "/var/lib/postgres/data" -m fast -w stop
exec "$@"