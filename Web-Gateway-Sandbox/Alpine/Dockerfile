# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Tag nginx:1.25.1-alpine3.17
FROM nginx:1.25.1-alpine3.17@sha256:647c5c83418c19eef0cddc647b9899326e3081576390c4c7baa4fce545123b6c
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV ODS_VIRTUAL_NAME=api
ENV SANDBOX_ADMIN_VIRTUAL_NAME=admin
ENV DOCS_VIRTUAL_NAME=docs

COPY ./default.conf.template /etc/nginx/templates/

EXPOSE 443
