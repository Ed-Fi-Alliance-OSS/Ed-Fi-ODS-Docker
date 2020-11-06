# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM postgres:11.5-alpine

LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV MINVERSION="5.1.0-b10351"
ENV POPULVERSION="5.1.0-b10337"

ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=postgres

COPY init-database.sh /docker-entrypoint-initdb.d/init-database.sh

RUN apk add unzip dos2unix && \
    wget -O /tmp/OdsMinimalDatabase.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Minimal.Template.PostgreSQL/${MINVERSION} && \
    wget -O /tmp/OdsPopulatedDatabse.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Populated.Template.PostgreSQL/${POPULVERSION} && \
    unzip -p /tmp/OdsPolulatedDatabase.zip EdFi.Ods.Populated.Template.sql > /tmp/EdFi_Ods_Populated_Template.sql && \
    unzip -p /tmp/OdsMinimalDatabase.zip EdFi.Ods.Minimal.Template.sql > /tmp/EdFi_Ods_Minimal_Template.sql && \
    rm -f /tmp/*.zip && \
    dos2unix /docker-entrypoint-initdb.d/init-database.sh && \
    dos2unix /tmp/*.sql

EXPOSE "5432"

CMD ["docker-entrypoint.sh", "postgres"]
