# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM postgres:11-alpine

LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV MINVERSION="5.1.0-b10359"
ENV POPULVERSION="5.1.0-b10345"
ENV ADMIN_VERSION="5.2.0-b10003"
ENV SECURITY_VERSION="5.2.0-b10025"

ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=postgres

COPY init-database.sh /docker-entrypoint-initdb.d/init-database.sh

RUN apk add unzip dos2unix && \
    wget -O /tmp/OdsMinimalDatabase.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Minimal.Template.PostgreSQL/${MINVERSION} && \
    wget -O /tmp/OdsPopulatedDatabase.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Populated.Template.PostgreSQL/${POPULVERSION} && \
    wget -O /tmp/EdFi_Admin.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Database.Admin.PostgreSQL/versions/${ADMIN_VERSION}/content && \
    wget -O /tmp/EdFi_Security.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Database.Security.PostgreSQL/versions/${SECURITY_VERSION}/content && \
    unzip -p /tmp/EdFi_Admin.zip EdFi_Admin.sql > /tmp/EdFi_Admin.sql && \
    unzip -p /tmp/EdFi_Security.zip EdFi_Security.sql > /tmp/EdFi_Security.sql && \
    unzip -p /tmp/OdsMinimalDatabase.zip EdFi.Ods.Minimal.Template.sql > /tmp/EdFi_Ods_Minimal_Template.sql && \
    unzip -p /tmp/OdsPopulatedDatabase.zip EdFi.Ods.Populated.Template.sql > /tmp/EdFi_Ods_Populated_Template.sql && \
    rm -f /tmp/*.zip && \
    dos2unix /docker-entrypoint-initdb.d/init-database.sh && \
    dos2unix /tmp/*.sql

EXPOSE "5432"

CMD ["docker-entrypoint.sh", "postgres"]

