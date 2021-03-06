# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=postgres

ENV ADMIN_VERSION="5.2.10083"
ENV SECURITY_VERSION="5.2.10103"
ENV ADMINAPP_DATABASE_VERSION="2.2.0"

COPY init-database.sh /docker-entrypoint-initdb.d/init-database.sh

RUN apk --no-cache add dos2unix=7.4.2-r0 unzip=6.0-r8 && \
    wget -O /tmp/EdFi_Admin.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Database.Admin.PostgreSQL/versions/${ADMIN_VERSION}/content && \
    wget -O /tmp/EdFi_Security.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Database.Security.PostgreSQL/versions/${SECURITY_VERSION}/content && \
    wget -O /tmp/EdFi_AdminApp_Scripts.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.ODS.AdminApp.Database/versions/${ADMINAPP_DATABASE_VERSION}/content && \
    unzip -p /tmp/EdFi_Admin.zip EdFi_Admin.sql > /tmp/EdFi_Admin.sql && \
    unzip -p /tmp/EdFi_Security.zip EdFi_Security.sql > /tmp/EdFi_Security.sql && \
    unzip /tmp/EdFi_AdminApp_Scripts.zip PgSql/* -d /tmp/AdminAppScripts/ && \
    dos2unix /docker-entrypoint-initdb.d/init-database.sh && \
    dos2unix /tmp/EdFi_Admin.sql && \
    dos2unix /tmp/EdFi_Security.sql && \
    dos2unix /tmp/AdminAppScripts/PgSql/*

EXPOSE 5432

CMD ["docker-entrypoint.sh", "postgres"]
