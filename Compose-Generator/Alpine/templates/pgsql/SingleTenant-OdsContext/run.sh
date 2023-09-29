#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

/app/mustache parameters /app/singleTenant-odsContext/appsettings-template.mustache > output/appsettings.docker.json
/app/mustache parameters /app/singleTenant-odsContext/bootstrap-template.mustache > output/bootstrap.sh
/app/mustache parameters /app/singleTenant-odsContext/compose-template.mustache > output/compose-single-tenant-odscontext-env.yml

dos2unix /output/*.sh
chmod 755 /output/bootstrap.sh