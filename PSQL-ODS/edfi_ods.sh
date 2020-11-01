export PGCLIENTENCODING="utf-8"

# Setup the minimal template
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE \"EdFi_Ods_Minimal_Template\";
    GRANT ALL PRIVILEGES ON DATABASE \"EdFi_Ods_Minimal_Template\" TO postgres;

EOSQL

# Load the minimal template
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "EdFi_Ods_Minimal_Template" < /app/EdFi.Ods.Minimal.Template.sql

# Mark the miminmal template as a template database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='EdFi_Ods_Minimal_Template';
    UPDATE pg_database SET datistemplate='true', datallowconn='false' WHERE datname in ('EdFi_Ods_Minimal_Template');

EOSQL

# Setup the populated template
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE \"Edfi_Ods_Populated_Template\";
    GRANT ALL PRIVILEGES ON DATABASE \"EdFi_Ods_Populated_Template\" TO postgres;

EOSQL

# Load the populated template
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "EdFi_Ods_Populated_Template" < /app/EdFi.Ods.Populated.Template.sql

# Mark the populated template as a template database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='EdFi_Ods_Populated_Template';
    UPDATE pg_database SET datistemplate='true', datallowconn='false' WHERE datname in ('EdFi_Ods_Populated_Template');

EOSQL

# Create a shared instance databse for production use
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE \"EdFi_Ods" TEMPLATE \"EdFi_Ods_MinimalTemplate\";

EOSQL