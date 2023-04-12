# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM mcr.microsoft.com/dotnet/core/aspnet@sha256:16332ec13dd77a8400edda0fb513b6ae204549adcd957aaa20dad6d26f645b5d
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="5.2.0-b13358"

WORKDIR /app
COPY appsettings.template.json /app/appsettings.template.json
COPY run.sh /app/run.sh
COPY log4net.config /app/log4net.txt

RUN apk --no-cache add unzip=~6.0 dos2unix=~7.4 bash=~5.1 gettext=~0.21 postgresql-client=~13.10 && \
    wget -O /app/SandboxAdmin.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.SandboxAdmin/${VERSION} && \
    unzip /app/SandboxAdmin.zip -d /app && \
    rm -f /app/SandboxAdmin.zip && \
    rm -f /app/appsettings.json && \
    cp /app/log4net.txt /app/log4net.config && \
    dos2unix /app/*.json && \
    dos2unix /app/*.sh && \
    dos2unix /app/log4net.config && \
    chmod 700 /app/run.sh && \
    rm -f /app/*.exe 

EXPOSE "80"

ENTRYPOINT ["/app/run.sh"]
