
#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE "EdFi_Ods_Populated_Template" TEMPLATE template0;
    GRANT ALL PRIVILEGES ON DATABASE "EdFi_Ods_Populated_Template" TO postgres;
    CREATE DATABASE "EdFi_Ods_Minimal_Template" TEMPLATE template0;
    GRANT ALL PRIVILEGES ON DATABASE "EdFi_Ods_Minimal_Template" TO postgres;
EOSQL

psql -v --no-password --tuples-only --username postgres --dbname "EdFi_Ods_Minimal_Template" --file /app/EdFi_Ods_Minimal_Template.sql

psql -v --no-password --tuples-only --username postgres --dbname "EdFi_Ods_Populated_Template" --file /app/EdFi_Ods_Populated_Template.sql

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
UPDATE pg_database SET datistemplate='true', datallowconn='false' WHERE datname in ('EdFi_Ods_Populated_Template', 'EdFi_Ods_Minimal_Template');
