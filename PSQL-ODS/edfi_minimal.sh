set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE EdFi_Ods_Minimal_Template;
    GRANT ALL PRIVILEGES ON DATABASE EdFi_Ods_Minimal_Template TO $POSTGRES_USER;
EOSQL
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "EdFi_Ods_Minimal_Template" < /app/EdFi.Ods.Minimal.Template.sql