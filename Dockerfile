FROM mcr.microsoft.com/dotnet/core/runtime:3.1-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
ENV VERSION="5.1.0-b12932"
RUN apk update && apk upgrade && apk add unzip
WORKDIR /app
RUN wget -O /app/Admin.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.SandboxAdmin/${VERSION} && unzip /app/Admin.zip -d /app && rm -f /app/Admin.zip
EXPOSE 80
ENTRYPOINT ["dotnet","EdFi.Ods.Sandbox.Admin.exe"]
