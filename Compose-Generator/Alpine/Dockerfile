# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Tag alpine:3.18.3
FROM alpine:3.18.3@sha256:7144f7bab3d4c2648d7e59409f15ec52a18006a128c733fcff20d3a4a54ba44a
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ARG VERSION="1.4.0"

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

RUN wget -O /tmp/mustache.tar.gz https://github.com/cbroglie/mustache/releases/download/v${VERSION}/mustache_${VERSION}_linux_amd64.tar.gz && \
    tar -xvzf /tmp/mustache.tar.gz -C /app && \
    rm -f /tmp/* && \
    mkdir /output && \
    chmod +x /*.sh

ENTRYPOINT ["/bin/sh"]
CMD ["singleTenant-odsContext.sh"]
