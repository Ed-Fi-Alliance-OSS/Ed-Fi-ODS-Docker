# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Tag nginx:alpine
FROM nginx@sha256:da9c94bec1da829ebd52431a84502ec471c8e548ffb2cedbf36260fd9bd1d4d3
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV ODS_VIRTUAL_NAME=api
ENV ADMINAPP_VIRTUAL_NAME=adminapp

COPY ./default.conf.template /etc/nginx/templates/

EXPOSE 443
