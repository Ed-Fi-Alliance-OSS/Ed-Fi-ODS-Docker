# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

docker-compose -f .\compose-shared-instance-env-build.yml down -v --remove-orphans

docker rmi docker_api docker_nginx -f

docker rmi docker_db-ods docker_db-admin -f
