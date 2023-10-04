# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

param(
    [ValidateSet('PostgreSQL')]
    [string] $Engine = 'PostgreSQL'
)

if ($Engine -eq 'PostgreSQL') {
    $engineFolder = "pgsql"
}

$composeFolder = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath Compose)).Path

$composeFile = Join-Path -Path $engineFolder -ChildPath MultiTenant-OdsContext/compose-multi-tenant-odscontext-env.yml

$envFile = (Join-Path -Path (Resolve-Path -Path $PSScriptRoot).Path -ChildPath .env)

docker-compose -f (Join-Path -Path $composeFolder -ChildPath $composeFile) --env-file $envFile down -v --remove-orphans

# Remove downloaded images
docker rmi $(docker images --filter=reference="edfialliance/ods-*" -q)
docker rmi $(docker images --filter=reference="bitnami/pgbouncer:*" -q)