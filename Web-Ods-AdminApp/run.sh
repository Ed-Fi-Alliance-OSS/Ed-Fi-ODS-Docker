#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

set -e
set -x

apk add jq

envsubst < /app/appsettings.template.json > /app/temp.json

measurementId=`jq -r '.AppSettings.GoogleAnalyticsMeasurementId' /app/appsettings.json`

tmp=$(mktemp)
jq --arg variable "$measurementId" '.AppSettings.GoogleAnalyticsMeasurementId = $variable' /app/temp.json > "$tmp" && mv "$tmp" /app/temp.json

mv /app/temp.json /app/appsettings.json

until PGPASSWORD=$POSTGRES_PASSWORD psql -h $ODS_POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -c '\q';
do
  >&2 echo "ODS Postgres is unavailable - sleeping"
  sleep 10
done

until PGPASSWORD=$POSTGRES_PASSWORD psql -h $ADMIN_POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -c '\q';
do
  >&2 echo "Admin Postgres is unavailable - sleeping"
  sleep 10
done

>&2 echo "Postgres is up - executing command"
exec $cmd

dotnet EdFi.Ods.AdminApp.Web.dll
