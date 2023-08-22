# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Tag alpine:3.18.3
FROM alpine:3.18.3@sha256:7144f7bab3d4c2648d7e59409f15ec52a18006a128c733fcff20d3a4a54ba44a
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="1.4.0"

COPY run.sh /app/run.sh
COPY templates/pgsql/template.mustache /app/template.mustache

RUN wget -O /tmp/mustache.tar.gz https://github.com/cbroglie/mustache/releases/download/v${VERSION}/mustache_${VERSION}_linux_amd64.tar.gz && \
    tar -xvzf /tmp/mustache.tar.gz -C /app && \
    rm -f /tmp/* && \
    chmod +x /app/*.sh

CMD ["/app/run.sh"]
