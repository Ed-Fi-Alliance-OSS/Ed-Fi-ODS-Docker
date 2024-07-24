# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Tag nginx:1.27.0-alpine3.19
FROM nginx:1.27.0-alpine3.19@sha256:208b70eefac13ee9be00e486f79c695b15cef861c680527171a27d253d834be9
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV ODS_VIRTUAL_NAME=api
ENV ADMINAPP_VIRTUAL_NAME=adminapp

COPY ./default.conf.template /etc/nginx/templates/

EXPOSE 443
