FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
ENV VERSION="5.1.0-b12104"
WORKDIR /app
RUN apk update && apk upgrade && apk add unzip
RUN wget -O /app/SwaggerUI.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.SwaggerUI/${VERSION} && unzip /app/SwaggerUI.zip -d /app && rm -f /app/SwaggerUI.zip
COPY swagger.appsettings.json /app/appsettings.json
EXPOSE 80
ENTRYPOINT ["dotnet","EdFi.Ods.SwaggerUI.dll"]
