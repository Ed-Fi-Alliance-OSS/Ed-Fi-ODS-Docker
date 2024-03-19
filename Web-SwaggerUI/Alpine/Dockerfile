# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

# Tag aspnet:3.1-alpine
FROM mcr.microsoft.com/dotnet/core/aspnet@sha256:04c3f55d802cdbaf23bf1ef86190bd8c1606cf07ff353619d24b030edc2afe54 AS base
RUN apk --upgrade --no-cache add unzip=~6.0 dos2unix=~7.4 bash=~5.1 gettext=~0.21 icu=~71.1 openssl=~1.1 e2fsprogs=~1.46

# Start a new layer so that the above layer can be cached
FROM base AS base-upgraded

LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="5.3.1499"
ENV DOCS_VIRTUAL_NAME=docs
ENV ODS_VIRTUAL_NAME=api
ENV WebApiVersionUrl="https://localhost/${ODS_VIRTUAL_NAME}/"
ENV UseReverseProxyHeaders=true
ENV PathBase="${DOCS_VIRTUAL_NAME}"

# Alpine image does not contain Globalization Cultures library so we need to
# install ICU library to get LINQ expression to work and disable the
# globaliztion invariant mode, which is set in the base image.
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

WORKDIR /app
COPY appsettings.template.json /app/appsettings.template.json
COPY run.sh /app/run.sh

RUN wget -O /app/SwaggerUI.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.SwaggerUI/versions/${VERSION}/content && \
    unzip /app/SwaggerUI.zip -d /app && \
    rm -f /app/SwaggerUI.zip && \
    dos2unix /app/*.json && \
    dos2unix /app/*.sh && \
    chmod 700 /app/run.sh && \
    rm -f /app/*.exe && \
    apk del unzip dos2unix

EXPOSE 80

ENTRYPOINT ["/app/run.sh"]
