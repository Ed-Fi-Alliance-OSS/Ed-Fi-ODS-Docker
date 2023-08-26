# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

#Requires -Version 5

<#

.SYNOPSIS
    Validates compose.yml files using the 'docker compose config' command.

.DESCRIPTION
    Uses ['docker compose config'](https://docs.docker.com/engine/reference/commandline/compose_config/) 
    to validate the structure and variables used in a compose.yml file.

    It will search recursively in all subfolders included in the $ComposeFilesPath parameter.

    The script will stop and display the corresponding error message if a compose file has errors.
    Since the objective is to validate compose structure, Warning messages raised by optional parameters not defined in the .env file 
    are suppressed.

.EXAMPLE
    PS> .\validate-compose-files.ps1

.EXAMPLE
    PS> .\validate-compose-files.ps1 -composeFilesPath OdsApi/7.0/Compose

.LINK
    https://docs.docker.com/engine/reference/commandline/compose_config/

#>
param(
    # Specifies the base path where all compose.yml files will be retrieved, searching recursively in all subfolders.
    [string]
    $ComposeFilesPath = "OdsApi/6.1/Compose"
)

$ErrorActionPreference = "Stop"

foreach ($composeFile in Get-ChildItem $ComposeFilesPath -Recurse -Filter *.yml -File){
    Write-Output "Validating: $composeFile"
    $result = & docker compose -f $composeFile --env-file .env.validation config -q 2>&1
    if ($LASTEXITCODE -gt 0) {
        Write-Error $result
    }
}
