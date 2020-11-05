FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV VERSION="5.1.0-b13218"

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
    rm -f /app/[Content] && \
    mv /app/sandbox.appsettings.json /app/appsettings.json

ENTRYPOINT ["dotnet", "EdFi.Ods.Sandbox.Admin.dll"]
