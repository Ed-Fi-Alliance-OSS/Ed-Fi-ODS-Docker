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
    $composeFilePath = [IO.Path]::Combine($PSScriptRoot, 'Compose', $engineFolder, 'SingleTenant', 'compose-single-tenant-env.yml')
    $composeOverrideFilePath = [IO.Path]::Combine($PSScriptRoot, 'Compose', $engineFolder, 'SingleTenant', 'compose-single-tenant-env.override.yml')
}
else {
    $engineFolder = "mssql"
    $composeFilePath = [IO.Path]::Combine($PSScriptRoot, 'Compose', $engineFolder, 'compose-single-tenant-env.yml')
    $composeOverrideFilePath = [IO.Path]::Combine($PSScriptRoot, 'Compose', $engineFolder, 'compose-single-tenant-env.override.yml')
}

$envFilePath = [IO.Path]::Combine($PSScriptRoot, '.env')

$params = @(
    "-f", $composeFilePath,
    "--env-file", $envFilePath,
    "-p", "single-tenant-ods",
    "up",
    "-d",
    "--remove-orphans"
)

# If the compose override exists, insert the -f parameter to get it merged
if (Test-Path $composeOverrideFilePath) {
    $params = $params[0..1] + "-f" + $composeOverrideFilePath + $params[2..8]
}

& docker compose $params
