# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Base image
FROM nginxinc/nginx-unprivileged:1.27.3-alpine3.20@sha256:10484850d007b13fe46c1d03dfcc9e3e77eb347889b999ac57c9f693039e3e0f
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV ODS_VIRTUAL_NAME=api
ENV SANDBOX_ADMIN_VIRTUAL_NAME=admin
ENV DOCS_VIRTUAL_NAME=docs

COPY ./default.conf.template /etc/nginx/templates/

EXPOSE 443
