# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

docker-compose -f .\docker-compose-sandbox.yml down -v --remove-orphans

docker rmi ed-fi-ods-docker_gateway ed-fi-ods-docker_swaggerui  -f

docker rmi ed-fi-ods-docker_web-ods ed-fi-ods-docker_web-sandbox-admin -f

docker rmi ed-fi-ods-docker_db-sandbox ed-fi-ods-docker_db-ods ed-fi-ods-docker_db-admin -f

docker volume rm $(docker volume ls -qf dangling=true)

docker system prune -f