#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE "EdFi_Admin" TEMPLATE template0;
    GRANT ALL PRIVILEGES ON DATABASE "EdFi_Admin" TO postgres;
    CREATE DATABASE "EdFi_Security" TEMPLATE template0;
    GRANT ALL PRIVILEGES ON DATABASE "EdFi_Security" TO postgres;
EOSQL

psql --no-password --tuples-only --username postgres --dbname "EdFi_Security" --file /tmp/EdFi_Security.sql

psql --no-password --tuples-only --username postgres --dbname "EdFi_Admin" --file /tmp/EdFi_Admin.sql
