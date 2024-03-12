# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM mcr.microsoft.com/dotnet/aspnet:8.0.3-alpine3.19-amd64@sha256:a531d9d123928514405b9da9ff28a3aa81bd6f7d7d8cfb6207b66c007e7b3075 AS base
RUN apk --no-cache add unzip=~6 dos2unix=~7 bash=~5 gettext=~0 icu=~74 curl=~8 && \
    addgroup -S edfi && adduser -S edfi -G edfi

# Start a new layer so that the above layer can be cached
FROM base AS build
RUN apk --no-cache jq=~1

LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="3.2.1"
ENV PGBOUNCER_LISTEN_PORT=6432
ENV ADMINAPP_VIRTUAL_NAME=adminapp
ENV API_MODE=SharedInstance

# Alpine image does not contain Globalization Cultures library so we need to install ICU library to get fopr LINQ expression to work
# Disable the globaliztion invariant mode (set in base image)
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

WORKDIR /app
COPY --chmod=600 appsettings.template.json /app/appsettings.template.json
COPY --chmod=500 run.sh /app/run.sh
COPY log4net.config /app/log4net.txt

RUN umask 0077 && \
    wget -O /app/AdminApp.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.ODS.AdminApp.Web/versions/${VERSION}/content && \
    unzip /app/AdminApp.zip AdminApp/* -d /app/ && \
    cp -r /app/AdminApp/. /app/ && \
    rm -f /app/AdminApp.zip && \
    rm -r /app/AdminApp && \
    cp /app/log4net.txt /app/log4net.config && \
    rm -f /app/log4net.txt && \
    dos2unix /app/*.json && \
    dos2unix /app/*.sh && \
    dos2unix /app/log4net.config && \
    rm -f /app/*.exe && \
    apk del unzip dos2unix curl && \
    chown -R edfi /app

EXPOSE 80
USER edfi
ENTRYPOINT [ "/app/run.sh" ]
