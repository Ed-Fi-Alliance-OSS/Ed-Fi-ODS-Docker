#!/bin/sh
#-- SPDX-License-Identifier: Apache-2.0
#-- Licensed to the Ed-Fi Alliance under one or more agreements.
#-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
#-- See the LICENSE and NOTICES files in the project root for more information.

# Creates the Ods_Minimal_Template and Ods_Populated_Template databases that Admin API's
# Instance Management feature (AppSettings__EnableDataStoreManagement) clones from when
# creating new ODS databases (CREATE DATABASE ... TEMPLATE Ods_Minimal_Template/Ods_Populated_Template).
# Mounted into each db-ods-tenantN-YYYY container; each one supplies its own
# SQL_BACKUPS_FOLDER/MINIMAL_SQL_PATH/POPULATED_SQL_PATH via that service's environment.
#
# NOTE: AppSettings__EnableDataStoreManagement itself is not wired up in this OdsContext
# compose file (see the comment in compose-multi-tenant-odscontext-env.yml), since there is no
# single ODS host per tenant for it to target. This script only pre-builds the template
# databases on each per-school-year ODS host, ahead of a future per-context wiring.
#
# This is optional: unless a SQL_BACKUPS_FOLDER volume is bind-mounted with the two SQL dump
# files (see compose-multi-tenant-odscontext-env.override.yml.example), the file-existence
# checks below skip template creation, so environments that don't use this are unaffected.

set -e
set +x

MINIMAL_SQL_PATH="${MINIMAL_SQL_PATH:-/var/opt/pgsql/data/sql-backups/EdFi.Ods.Minimal.Template.sql}"
POPULATED_SQL_PATH="${POPULATED_SQL_PATH:-/var/opt/pgsql/data/sql-backups/EdFi.Ods.Populated.Template.sql}"

create_template_database() {
    db_name="$1"
    sql_path="$2"

    if [ ! -f "$sql_path" ]; then
        echo "WARNING: '$sql_path' not found - skipping $db_name setup."
        return 0
    fi

    echo "Creating and restoring $db_name from $sql_path..."
    psql --username "$POSTGRES_USER" --dbname postgres -v ON_ERROR_STOP=1 \
        -c "CREATE DATABASE \"$db_name\";"
    psql --username "$POSTGRES_USER" --dbname "$db_name" -v ON_ERROR_STOP=1 \
        -f "$sql_path"
    psql --username "$POSTGRES_USER" --dbname postgres -v ON_ERROR_STOP=1 \
        -c "UPDATE pg_database SET datistemplate = true WHERE datname = '$db_name';"
}

create_template_database "Ods_Minimal_Template" "$MINIMAL_SQL_PATH"
create_template_database "Ods_Populated_Template" "$POPULATED_SQL_PATH"
