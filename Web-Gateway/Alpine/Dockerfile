# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Tag nginx:1.24.0-alpine3.17
FROM nginx:1.24.0-alpine3.17@sha256:76ca7f6bfe01c3e22e3af85fd37c30149ece3ac2a444973687cab1765abca115
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV ODS_VIRTUAL_NAME=api
ENV ADMINAPP_VIRTUAL_NAME=adminapp

COPY ./default.conf.template /etc/nginx/templates/

EXPOSE 443
