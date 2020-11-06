# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

docker-compose -f .\docker-compose-sandbox-env.yml down -v --remove-orphans

docker rmi ed-fi-ods ed-fi-sandbox-admin ed-fi-swagger ed-fi-gateway -f

docker rmi ed-fi-db -f

docker volume rm $(docker volume ls -qf dangling=true)

docker system prune -f