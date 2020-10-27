FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
ENV VERSION="5.1.0-b12868"
RUN apk update && apk upgrade && apk add unzip
WORKDIR /app
RUN wget -O /app/WebApi.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.WebApi/${VERSION} && unzip /app/WebApi.zip -d /app && rm -f /app/WebApi.zip
COPY webapi.appsettings.json /app/appsettings.json
EXPOSE 80
ENTRYPOINT ["dotnet","EdFi.Ods.WebApi.dll"]
