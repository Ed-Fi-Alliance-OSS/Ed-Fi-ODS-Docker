# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Tag postgres:11-alpine
FROM postgres:11.22-alpine3.19@sha256:33a78858869c44785eee197a60cf281c5c80376bb725992f092ec5e7e072f3de AS base
RUN apk --upgrade --no-cache add dos2unix=~7.5 unzip=~6.0 openssl=~3 libxml2=~2.11 ncurses=~6 e2fsprogs=~1.47 busybox=~1.36

# Start a new layer so that the above layer can be cached
FROM base AS base-upgraded

LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV MINVERSION="5.4.1042"
ENV POPULVERSION="5.4.999"
ENV MINTPDMVERSION="5.4.832"
ENV POPULTPDMVERSION="5.4.825"

ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=postgres

COPY init-database.sh /docker-entrypoint-initdb.d/init-database.sh

    # Download and extract Minimal and Populated Templates for core Ed-Fi Data Model
RUN wget -O /tmp/OdsMinimalDatabase.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.Minimal.Template.PostgreSQL/versions/${MINVERSION}/content && \
    wget -O /tmp/OdsPopulatedDatabase.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.Populated.Template.PostgreSQL/versions/${POPULVERSION}/content && \
    unzip -p /tmp/OdsMinimalDatabase.zip EdFi.Ods.Minimal.Template.sql > /tmp/EdFi_Ods_Minimal_Template.sql && \
    unzip -p /tmp/OdsPopulatedDatabase.zip EdFi.Ods.Populated.Template.sql > /tmp/EdFi_Ods_Populated_Template.sql && \
    # Download and extract Minimal and Populated Templates for Teacher Prep Data Model (TPDM)
    wget -O /tmp/TPDMOdsMinimalDatabase.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.Minimal.Template.TPDM.Core.PostgreSQL/versions/${MINTPDMVERSION}/content && \
    wget -O /tmp/TPDMOdsPopulatedDatabase.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.Populated.Template.TPDM.Core.PostgreSQL/versions/${POPULTPDMVERSION}/content && \
    unzip -p /tmp/TPDMOdsMinimalDatabase.zip EdFi.Ods.Minimal.Template.TPDM.Core.sql > /tmp/EdFi_Ods_Minimal_Template_TPDM_Core.sql && \
    unzip -p /tmp/TPDMOdsPopulatedDatabase.zip EdFi.Ods.Populated.Template.TPDM.Core.sql > /tmp/EdFi_Ods_Populated_Template_TPDM_Core.sql && \
    rm -f /tmp/*.zip && \
    dos2unix /docker-entrypoint-initdb.d/init-database.sh && \
    dos2unix /tmp/*.sql && \
    apk del unzip dos2unix

EXPOSE 5432

CMD ["docker-entrypoint.sh", "postgres"]

