# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

docker-compose -f .\compose-sandbox-env-build.yml down -v --remove-orphans

docker rmi ed-fi-ods-docker_api ed-fi-ods-docker_swagger ed-fi-swagger ed-fi-ods-docker_nginx ed-fi-ods-docker_admin  -f

docker rmi ed-fi-ods-docker_db-ods ed-fi-ods-docker_db-admin -f
