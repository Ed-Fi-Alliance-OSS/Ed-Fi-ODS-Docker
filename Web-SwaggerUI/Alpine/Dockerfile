# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM mcr.microsoft.com/dotnet/aspnet:8.0.2-jammy-chiseled@sha256:cb35170c5c4687e42749a4f3538e6667cd682493466cc1535d8579befc23e077
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="6.2.2329"
ENV DOCS_VIRTUAL_NAME=docs
ENV ODS_VIRTUAL_NAME=api
ENV WebApiVersionUrl="https://localhost/${ODS_VIRTUAL_NAME}/"
ENV UseReverseProxyHeaders=true
ENV PathBase="${DOCS_VIRTUAL_NAME}"

# Alpine image does not contain Globalization Cultures library so we need to install ICU library to get fopr LINQ expression to work
# Disable the globaliztion invariant mode (set in base image)
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

WORKDIR /app
COPY appsettings.template.json /app/appsettings.template.json
COPY run.sh /app/run.sh

RUN apk --no-cache add unzip=~6 dos2unix=~7 bash=~5 gettext=~0 icu=~72 curl=~8 && \
    wget -O /app/SwaggerUI.zip https://pkgs.dev.azure.com/ed-fi-alliance/Ed-Fi-Alliance-OSS/_apis/packaging/feeds/EdFi/nuget/packages/EdFi.Suite3.Ods.SwaggerUI/versions/${VERSION}/content && \
    unzip /app/SwaggerUI.zip -d /app && \
    rm -f /app/SwaggerUI.zip && \
    dos2unix /app/*.json && \
    dos2unix /app/*.sh && \
    chmod 700 /app/run.sh && \
    rm -f /app/*.exe

EXPOSE 80

ENTRYPOINT ["/app/run.sh"]
