FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="5.2.0-b13315"

WORKDIR /app
COPY swagger.appsettings.json /app/swagger.appsettings.json

RUN apk add unzip dos2unix bash && \
    wget -O /app/SwaggerUI.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.SwaggerUI/${VERSION} && \
    unzip /app/SwaggerUI.zip -d /app && \
    rm -f /app/SwaggerUI.zip && \
    dos2unix /app/*.json && \
    rm -f /app/*.exe && \
    rm -f /app/[Content_Types] && \
    mv /app/swagger.appsettings.json /app/appsettings.json

EXPOSE "80"

ENTRYPOINT ["dotnet","EdFi.Ods.SwaggerUI.dll"]
