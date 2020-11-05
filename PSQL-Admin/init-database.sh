#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE "EdFi_Admin" TEMPLATE template0;
    GRANT ALL PRIVILEGES ON DATABASE "EdFi_Admin" TO postgres;
    CREATE DATABASE "EdFi_Security" TEMPLATE template0;
    GRANT ALL PRIVILEGES ON DATABASE "EdFi_Security" TO postgres;
EOSQL

psql --no-password --tuples-only --username postgres --dbname "EdFi_Security" --file /tmp/EdFi_Security.sql

psql --no-password --tuples-only --username postgres --dbname "EdFi_Admin" --file /tmp/EdFi_Admin.sql

rm -rf /tmp/*.sql