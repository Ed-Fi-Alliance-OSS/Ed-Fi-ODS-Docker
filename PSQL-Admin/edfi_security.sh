#!/usr/bin/bash
set -e
psql -v ON_ERROR_STOP=1 --username 'postgres' <<-EOSQL
    #CREATE USER postgres with superuser password 'pgpassword';
    CREATE DATABASE EdFi_Admin;
    GRANT ALL PRIVILEGES ON DATABASE EdFi_Security TO postgres;
EOSQL