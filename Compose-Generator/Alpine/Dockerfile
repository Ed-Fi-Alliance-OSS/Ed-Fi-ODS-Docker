# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Use updated golang environment to build the mustache tool
FROM golang:1.20.12-alpine3.18@sha256:b482fd8d206e426a31db436ef9d0026b599571a6c4345d9e6c11d0742cd01589 as builder
RUN go install github.com/cbroglie/mustache/...@v1.4.0

# Tag alpine:3.18.5
FROM alpine:3.18.5@sha256:34871e7290500828b39e22294660bee86d966bc0017544e848dd9a255cdf59e0
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

COPY templates/pgsql/compose-override-template.mustache /app/compose-override-template.mustache

# Copy SingleTenant multi year artifacts
COPY templates/pgsql/SingleTenant-OdsContext/run.sh /singleTenant-odsContext.sh
COPY templates/pgsql/SingleTenant-OdsContext/appsettings-template.mustache /app/singleTenant-odsContext/appsettings-template.mustache
COPY templates/pgsql/SingleTenant-OdsContext/bootstrap-template.mustache /app/singleTenant-odsContext/bootstrap-template.mustache
COPY templates/pgsql/SingleTenant-OdsContext/compose-template.mustache /app/singleTenant-odsContext/compose-template.mustache

# Copy MultiTenant artifacts
COPY templates/pgsql/MultiTenant/run.sh /multiTenant.sh
COPY templates/pgsql/MultiTenant/appsettings-template.mustache /app/multiTenant/appsettings-template.mustache
COPY templates/pgsql/MultiTenant/bootstrap-template.mustache /app/multiTenant/bootstrap-template.mustache
COPY templates/pgsql/MultiTenant/compose-template.mustache /app/multiTenant/compose-template.mustache

# Copy MultiTenant-OdsContext artifacts
COPY templates/pgsql/MultiTenant-OdsContext/run.sh /multiTenant-OdsContext.sh
COPY templates/pgsql/MultiTenant-OdsContext/appsettings-template.mustache /app/multiTenant-OdsContext/appsettings-template.mustache
COPY templates/pgsql/MultiTenant-OdsContext/bootstrap-template.mustache /app/multiTenant-OdsContext/bootstrap-template.mustache
COPY templates/pgsql/MultiTenant-OdsContext/compose-template.mustache /app/multiTenant-OdsContext/compose-template.mustache

RUN mkdir /output && \
    chmod +x /*.sh

COPY --from=builder /go/bin/mustache /app

ENTRYPOINT ["/bin/sh"]
CMD ["singleTenant-odsContext.sh"]
