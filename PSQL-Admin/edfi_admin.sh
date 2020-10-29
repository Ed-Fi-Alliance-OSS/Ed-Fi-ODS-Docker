set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE EdFi_Admin;
    GRANT ALL PRIVILEGES ON DATABASE EdFi_Admin TO $POSTGRES_USER;
EOSQL
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "EdFi_Admin" < /app/EdFi_Admin.sql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE EdFi_Security;
    GRANT ALL PRIVILEGES ON DATABASE EdFi_Security TO $POSTGRES_USER;
EOSQL
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "EdFi_Security" < /app/EdFi_Security.sql