# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="5.1.0-b13218"

WORKDIR /app
COPY webapi.appsettings.json /app/web.appsettings.json

RUN apk add unzip dos2unix bash && \
    wget -O /app/WebApi.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.WebApi/${VERSION} && \
    unzip /app/WebApi.zip -d /app && \
    rm -f /app/WebApi.zip && \
    dos2unix /app/*.json && \
    rm -f /app/*.exe && \
    rm -f /app/[Content] && \
    mv /app/web.appsettings.json /app/appsettings.json

EXPOSE 80

ENTRYPOINT ["dotnet", "EdFi.Ods.WebApi.dll"]
