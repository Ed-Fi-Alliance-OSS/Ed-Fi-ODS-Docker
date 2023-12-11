# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Base image
FROM nginxinc/nginx-unprivileged:1.25.3-alpine3.18@sha256:fa82525b9e33387b17d560ea9a40b1bdcb1816df55af7a7597ebfb55f2a8c56b
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV ODS_VIRTUAL_NAME=api
ENV ADMIN_API_VIRTUAL_NAME=adminapi

COPY ./default.conf.template /etc/nginx/templates/

EXPOSE 443
