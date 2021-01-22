# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

docker-compose -f .\compose-shared-instance-env-build.yml down -v --remove-orphans

# On some systems the images build by `shared-instance-env-up.ps` have names
# that are prefixed with "ed-fi-ods-", while others do not. So loook for both
# formats to remove.
@(
    "ed-fi-ods-docker_api",
    "ed-fi-ods-docker_nginx",
    "ed-fi-ods-docker_db-ods",
    "ed-fi-ods-docker_db-admin",
    "ed-fi-ods-docker_adminapp",
    "docker_api",
    "docker_nginx",
    "docker_db-ods",
    "docker_db-admin",
    "docker_adminapp"
) | ForEach-Object {

    $exists = (&docker images -q $_)
    if ($exists) {
        docker rmi -f $_
    }
}
