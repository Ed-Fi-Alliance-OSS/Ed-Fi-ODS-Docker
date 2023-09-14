#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

set -e
set +x

if [[ -z "$POSTGRES_PORT" ]]; then
  export POSTGRES_PORT=5432
fi

echo "Setting up 2022 ODS Instance..."
psql --username "$POSTGRES_USER" --port $POSTGRES_PORT --dbname "EdFi_Admin" <<-EOSQL

\set ods_instance_name '2022'
\set ods_instance_type 'ODS'
\set context_key '${CONTEXT_KEY}'
\set context_value '2022'
\set ods_instance_connection_string 'host=edfi_ods_2022;port=${ODS_PGBOUNCER_PORT};username=${POSTGRES_USER};password=${POSTGRES_PASSWORD};database=EdFi_Ods;pooling=${NPG_POOLING_ENABLED};minimum pool size=10;maximum pool size=${NPG_API_MAX_POOL_SIZE_ODS};Application Name=EdFi.Ods.WebApi'

INSERT INTO dbo.OdsInstances (Name, InstanceType, ConnectionString)
SELECT :'ods_instance_name', :'ods_instance_type', :'ods_instance_connection_string'
WHERE NOT EXISTS (SELECT 1 FROM dbo.OdsInstances WHERE Name = :'ods_instance_name' AND InstanceType = :'ods_instance_type');

SELECT LASTVAL() AS ods_instance_id;
\gset

INSERT INTO dbo.OdsInstanceContext (OdsInstanceId, ContextKey, ContextValue)
SELECT :ods_instance_id, :'context_key', :'context_value'
WHERE NOT EXISTS (SELECT 1 FROM dbo.OdsInstanceContext WHERE OdsInstanceId = :ods_instance_id AND ContextKey = :'context_key' AND ContextValue = :'context_value');

EOSQL


echo "Setting up 2023 ODS Instance..."
psql --username "$POSTGRES_USER" --port $POSTGRES_PORT --dbname "EdFi_Admin" <<-EOSQL

\set ods_instance_name '2023'
\set ods_instance_type 'ODS'
\set context_key '${CONTEXT_KEY}'
\set context_value '2023'
\set ods_instance_connection_string 'host=edfi_ods_2023;port=${ODS_PGBOUNCER_PORT};username=${POSTGRES_USER};password=${POSTGRES_PASSWORD};database=EdFi_Ods;pooling=${NPG_POOLING_ENABLED};minimum pool size=10;maximum pool size=${NPG_API_MAX_POOL_SIZE_ODS};Application Name=EdFi.Ods.WebApi'

INSERT INTO dbo.OdsInstances (Name, InstanceType, ConnectionString)
SELECT :'ods_instance_name', :'ods_instance_type', :'ods_instance_connection_string'
WHERE NOT EXISTS (SELECT 1 FROM dbo.OdsInstances WHERE Name = :'ods_instance_name' AND InstanceType = :'ods_instance_type');

SELECT LASTVAL() AS ods_instance_id;
\gset

INSERT INTO dbo.OdsInstanceContext (OdsInstanceId, ContextKey, ContextValue)
SELECT :ods_instance_id, :'context_key', :'context_value'
WHERE NOT EXISTS (SELECT 1 FROM dbo.OdsInstanceContext WHERE OdsInstanceId = :ods_instance_id AND ContextKey = :'context_key' AND ContextValue = :'context_value');

EOSQL


