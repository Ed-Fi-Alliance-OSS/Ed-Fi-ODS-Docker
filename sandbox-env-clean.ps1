# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.


param(
    [ValidateSet('PostgreSQL', 'SQLServer')]
    [string] $Engine = 'PostgreSQL'
)


if ($Engine -eq 'PostgreSQL') {
    $engineFolder = "pgsql"
}
else {
    $engineFolder = "mssql"
}

$composeFolder = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath Compose)).Path

$composeFile = Join-Path -Path $engineFolder -ChildPath compose-sandbox-env-build.yml

$envFile = (Join-Path -Path (Resolve-Path -Path $PSScriptRoot).Path -ChildPath .env)

docker-compose -f (Join-Path -Path $composeFolder -ChildPath $composeFile) --env-file $envFile down -v --remove-orphans

@(
    "ed-fi-ods-docker_api",
    "ed-fi-ods-docker_nginx",
    "ed-fi-ods-docker_swagger",
    "ed-fi-ods-docker_db-ods",
    "ed-fi-ods-docker_db-admin",
    "ed-fi-ods-docker_pb-admin",
    "ed-fi-ods-docker_pb-admin",
    "pgsql_swagger",
    "pgsql_nginx",
    "pgsql_admin",
    "pgsql_db-ods",
    "pgsql_db-admin",
    "pgsql_pb-ods",
    "pgsql-pb-admin",
    "pgsql_pg-ods",
    "pgsql_pg-admin",
    "mssql_swagger",
    "mssql_nginx",
    "mssql_admin",
    "mssql_db-ods",
    "mssql_db-admin",
    "mssql_pb-ods",
    "mssql-pb-admin",
    "mssql_pg-ods",
    "mssql_pg-admin"
) | ForEach-Object {

    $exists = (&docker images -q $_)
    if ($exists) {
        docker rmi $_ -f
    }
}
