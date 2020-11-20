# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="5.2.0-b13358"

WORKDIR /app
COPY sandbox.appsettings.json /app/sandbox.appsettings.json
#COPY pgpass.conf /app/.pgpass

RUN apk add unzip dos2unix bash && \
    wget -O /app/SandboxAdmin.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.SandboxAdmin/${VERSION} && \
    unzip /app/SandboxAdmin.zip -d /app && \
    rm -f /app/SandboxAdmin.zip && \
    rm -f /app/appsettings.json && \
    dos2unix /app/*.json && \
    rm -f /app/*.exe && \
    rm -f /app/[Content_Types] && \
    mv /app/sandbox.appsettings.json /app/appsettings.json

EXPOSE "80"

ENTRYPOINT ["dotnet", "EdFi.Ods.Sandbox.Admin.dll"]
