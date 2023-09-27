#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

/app/mustache parameters /app/multiTenant/appsettings-template.mustache > output/appsettings.dockertemplate.json
/app/mustache parameters /app/multiTenant/bootstrap-template.mustache > output/bootstrap.sh
/app/mustache parameters /app/multiTenant/compose-template.mustache > output/compose-multi-tenant-env.yml
