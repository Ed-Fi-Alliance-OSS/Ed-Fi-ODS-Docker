set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE edfi_ods_minimal_template;
    GRANT ALL PRIVILEGES ON DATABASE edfi_ods_minimal_template TO $POSTGRES_USER;
EOSQL
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "edfi_ods_minimal_template" < /app/EdFi.Ods.Minimal.Template.sql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE edfi_ods_populated_template;
    GRANT ALL PRIVILEGES ON DATABASE edfi_ods_populated_template TO $POSTGRES_USER;
EOSQL
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "edfi_ods_populated_template" < /app/EdFi.Ods.Populated.Template.sql