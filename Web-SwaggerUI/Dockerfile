# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM mcr.microsoft.com/dotnet/core/aspnet@sha256:04c3f55d802cdbaf23bf1ef86190bd8c1606cf07ff353619d24b030edc2afe54
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="5.2.0-b13315"

WORKDIR /app
COPY appsettings.template.json /app/appsettings.template.json
COPY run.sh /app/run.sh

RUN apk --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main add unzip=~6 dos2unix=7.4.2-r0 bash=~5 gettext=~0 postgresql-client=~11 icu=~71 && \
    wget -O /app/SwaggerUI.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.SwaggerUI/${VERSION} && \
    unzip /app/SwaggerUI.zip -d /app && \
    rm -f /app/SwaggerUI.zip && \
    dos2unix /app/*.json && \
    dos2unix /app/*.sh && \
    chmod 700 /app/run.sh && \
    rm -f /app/*.exe

EXPOSE "80"

ENTRYPOINT ["/app/run.sh"]
