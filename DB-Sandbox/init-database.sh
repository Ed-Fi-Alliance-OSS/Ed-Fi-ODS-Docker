#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

set -e
set -v

psql ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE "EdFi_Ods_Minimal_Template" TEMPLATE template0;
    CREATE DATABASE "EdFi_Ods_Populated_Template" TEMPLATE template0;
    GRANT ALL PRIVILEGES ON DATABASE "EdFi_Ods_Populated_Template" TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE "EdFi_Ods_Minimal_Template" TO $POSTGRES_USER;
EOSQL

psql --no-password --tuples-only --username "$POSTGRES_USER" --dbname "EdFi_Ods_Minimal_Template" --file /tmp/EdFi_Ods_Minimal_Template.sql

psql --no-password --tuples-only --username "$POSTGRES_USER" --dbname "EdFi_Ods_Populated_Template" --file /tmp/EdFi_Ods_Populated_Template.sql

psql ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    UPDATE pg_database SET datistemplate='true', datallowconn='false' WHERE datname in ('EdFi_Ods_Populated_Template', 'EdFi_Ods_Minimal_Template');
EOSQL
