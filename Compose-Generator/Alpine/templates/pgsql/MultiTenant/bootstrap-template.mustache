#!/bin/sh
#-- SPDX-License-Identifier: Apache-2.0
#-- Licensed to the Ed-Fi Alliance under one or more agreements.
#-- The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
#-- See the LICENSE and NOTICES files in the project root for more information.

set -e
set +x

if [[ -z "$POSTGRES_PORT" ]]; then
  export POSTGRES_PORT=5432
fi

EDFI_ODS_CONNECTION_STRING="host=$ODS_POSTGRES_HOST;port=$ODS_PGBOUNCER_PORT;username=$POSTGRES_USER;password=$POSTGRES_PASSWORD;database=EdFi_Ods;application name=EdFi.Ods.WebApi;pooling=${NPG_POOLING_ENABLED};minimum pool size=10;maximum pool size=${NPG_API_MAX_POOL_SIZE_ODS};"

echo "Setting up Multi Tenant for $TENANT_IDENTIFIER.."
psql --username "$POSTGRES_USER" --port $POSTGRES_PORT --dbname "EdFi_Admin" <<-EOSQL

UPDATE dbo.OdsInstances SET ConnectionString = '$EDFI_ODS_CONNECTION_STRING'
WHERE  EXISTS (SELECT 1 FROM dbo.OdsInstances WHERE Name = '$TENANT_IDENTIFIER ODS' AND InstanceType = 'ODS');

INSERT INTO dbo.OdsInstances (Name, InstanceType, ConnectionString)
SELECT '$TENANT_IDENTIFIER ODS', 'ODS', '$EDFI_ODS_CONNECTION_STRING'
WHERE NOT EXISTS (SELECT 1 FROM dbo.OdsInstances WHERE Name = '$TENANT_IDENTIFIER ODS' AND InstanceType = 'ODS');

EOSQL
