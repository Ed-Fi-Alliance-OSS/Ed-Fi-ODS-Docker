# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

param(
    [ValidateSet('pgsql')]
    [string] $Engine = 'pgsql'
)

$composeFolder = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath Compose)).Path

$composeFile = Join-Path -Path $Engine -ChildPath \MultiTenant\compose-multi-tenant-env.yml

$envFile = (Join-Path -Path (Resolve-Path -Path $PSScriptRoot).Path -ChildPath .env)

docker-compose -f (Join-Path -Path $composeFolder -ChildPath $composeFile) --env-file $envFile up -d --build --remove-orphans

docker exec -it ed-fi-ods-api sh -c "envsubst < /app/appsettings.dockertemplate.json > /app/appsettings.docker.json"

docker restart ed-fi-ods-api