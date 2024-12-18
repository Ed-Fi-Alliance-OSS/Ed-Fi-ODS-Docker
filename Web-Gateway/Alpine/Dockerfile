# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Base image
FROM nginxinc/nginx-unprivileged:1.27-alpine3.20@sha256:6097fa6666257aa3e991a2d4b48df07468ea3adb58acba3ab9c6de34c664d714
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV ODS_VIRTUAL_NAME=api
ENV ADMIN_API_VIRTUAL_NAME=adminapi
ENV ADMIN_CONSOLE_VIRTUAL_NAME=adminconsole
ENV KEYCLOAK_VIRTUAL_NAME=keycloak

COPY ./default.conf.template /etc/nginx/templates/

EXPOSE 443
