# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM mcr.microsoft.com/dotnet/core/aspnet@sha256:04c3f55d802cdbaf23bf1ef86190bd8c1606cf07ff353619d24b030edc2afe54
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="5.2.14406"
ENV POSTGRES_PORT=5432
ENV PGBOUNCER_LISTEN_PORT=6432
ENV ODS_VIRTUAL_NAME=api
ENV ApiSettings__PathBase="${ODS_VIRTUAL_NAME}"

# Alpine image does not contain Globalization Cultures library so we need to install ICU library to get fopr LINQ expression to work
# Disable the globaliztion invariant mode (set in base image)
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

WORKDIR /app
COPY appsettings.template.json /app/appsettings.template.json
COPY run.sh /app/run.sh
COPY log4net.config /app/log4net.txt

RUN apk --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main add unzip=~6 dos2unix=7.4.2-r0 bash=~5 gettext=~0 postgresql-client=~11 icu=~71 && \
    wget -O /app/WebApi.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.WebApi/versions/${VERSION}/content && \
    unzip /app/WebApi.zip -d /app && \
    rm -f /app/WebApi.zip && \
    cp /app/log4net.txt /app/log4net.config && \
    dos2unix /app/*.json && \
    dos2unix /app/*.sh && \
    dos2unix /app/log4net.config && \
    chmod 700 /app/*.sh -- ** && \
    rm -f /app/*.exe

EXPOSE 80

ENTRYPOINT [ "/app/run.sh" ]
