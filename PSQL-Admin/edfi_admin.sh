psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE edfi_admin;
    GRANT ALL PRIVILEGES ON DATABASE edfi_admin TO postgres;
EOSQL
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "edfi_admin" < /app/EdFi_Admin.sql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE edfi_security;
    GRANT ALL PRIVILEGES ON DATABASE edfi_security TO postgres;
EOSQL
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "edfi_security" < /app/EdFi_Security.sql