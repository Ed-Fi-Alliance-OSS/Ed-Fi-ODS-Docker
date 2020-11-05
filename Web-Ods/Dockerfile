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

ENTRYPOINT ["dotnet", "EdFi.Ods.WebApi.dll"]
