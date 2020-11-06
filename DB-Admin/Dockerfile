# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=postgres

COPY *.sql /tmp/
COPY init-database.sh /docker-entrypoint-initdb.d/init-database.sh

RUN apk add dos2unix && \
    dos2unix /docker-entrypoint-initdb.d/init-database.sh && \
    dos2unix /tmp/EdFi_Admin.sql && \
    dos2unix /tmp/EdFi_Security.sql

EXPOSE "5432"

CMD ["docker-entrypoint.sh", "postgres"]
