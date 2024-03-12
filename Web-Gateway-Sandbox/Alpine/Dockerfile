# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM nginx:1.25.4-alpine@sha256:6a2f8b28e45c4adea04ec207a251fd4a2df03ddc930f782af51e315ebc76e9a9
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV ODS_VIRTUAL_NAME=api
ENV SANDBOX_ADMIN_VIRTUAL_NAME=admin
ENV DOCS_VIRTUAL_NAME=docs

COPY ./default.conf.template /etc/nginx/templates/

EXPOSE 443
