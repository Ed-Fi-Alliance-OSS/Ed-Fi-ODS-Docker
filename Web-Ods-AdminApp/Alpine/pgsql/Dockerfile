# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Tag aspnet:6.0-alpine
FROM mcr.microsoft.com/dotnet/aspnet@sha256:201cedd60cb295b2ebea7184561a45c5c0ee337e37300ea0f25cff5a2c762538
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="3.1.1"
ENV POSTGRES_PORT=5432
ENV PGBOUNCER_LISTEN_PORT=6432
ENV NPG_POOLING_ENABLED=false
ENV ADMINAPP_VIRTUAL_NAME=adminapp
ENV API_MODE=SharedInstance

# Alpine image does not contain Globalization Cultures library so we need to install ICU library to get fopr LINQ expression to work
# Disable the globaliztion invariant mode (set in base image)
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

WORKDIR /app
COPY appsettings.template.json /app/appsettings.template.json
COPY run.sh /app/run.sh
COPY log4net.config /app/log4net.txt

RUN apk --no-cache add unzip=~6 dos2unix=~7 bash=~5 gettext=~0 postgresql13-client=~13 jq=~1 icu=~72 curl=~8 && \
    wget -O /app/AdminApp.zip  https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.ODS.AdminApp.Web/versions/${VERSION}/content && \
    unzip /app/AdminApp.zip AdminApp/* -d /app/ && \
    cp -r /app/AdminApp/. /app/ && \
    rm -f /app/AdminApp.zip && \
    rm -r /app/AdminApp && \
    cp /app/log4net.txt /app/log4net.config && \
    dos2unix /app/*.json && \
    dos2unix /app/*.sh && \
    dos2unix /app/log4net.config && \
    chmod 700 /app/*.sh -- ** && \
    rm -f /app/*.exe

EXPOSE 80

ENTRYPOINT [ "/app/run.sh" ]
