# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Tag aspnet:8-alpine
FROM mcr.microsoft.com/dotnet/aspnet:8.0.3-alpine3.19@sha256:646b1c5ff36375f35f6149b0ce19ca095f97b4b882b90652801e9fbe82bcfa8a AS base
RUN apk --upgrade --no-cache add unzip=~6.0 dos2unix=~7.5 bash=~5.2 gettext=~0.22 icu=~74.1 openssl=~3.1 e2fsprogs=~1.47 busybox=~1.36

# Start a new layer so that the above layer can be cached
FROM base AS base-upgraded

LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="5.4.2272"
ENV POSTGRES_PORT=5432
ENV PGBOUNCER_LISTEN_PORT=6432
ENV ODS_VIRTUAL_NAME=api
ENV PathBase=admin
ENV OAuthUrl="https://localhost/${ODS_VIRTUAL_NAME}/oauth/"

# Alpine image does not contain Globalization Cultures library so we need to install ICU library to get fopr LINQ expression to work
# Disable the globaliztion invariant mode (set in base image)
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

WORKDIR /app
COPY appsettings.template.json /app/appsettings.template.json
COPY run.sh /app/run.sh
COPY log4net.config /app/log4net.txt

RUN apk --no-cache add postgresql14-client=~14.12 && \
    wget -O /app/SandboxAdmin.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.SandboxAdmin/versions/${VERSION}/content && \
    unzip /app/SandboxAdmin.zip -d /app && \
    rm -f /app/SandboxAdmin.zip && \
    rm -f /app/appsettings.json && \
    cp /app/log4net.txt /app/log4net.config && \
    dos2unix /app/*.json && \
    dos2unix /app/*.sh && \
    dos2unix /app/log4net.config && \
    chmod 700 /app/run.sh && \
    rm -f /app/*.exe && \
    apk del unzip dos2unix

ENV ASPNETCORE_HTTP_PORTS=80
EXPOSE 80

ENTRYPOINT ["/app/run.sh"]
