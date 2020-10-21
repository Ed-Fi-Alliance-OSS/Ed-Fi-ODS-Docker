FROM mcr.microsoft.com/dotnet/core/runtime:3.1-alpine
LABEL maintainer="EdFi Innive"
WORKDIR /app
EXPOSE 443
EXPOSE 80
RUN apk update && apk upgrade && apk add zip unzip
RUN wget https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.SandboxAdmin/5.1.0-b12932
RUN mv 5.1.0-b12932 5.1.0-b12932.zip
COPY . /app
RUN chmod 777 /app
ENTRYPOINT ["/bin/sh","EdFi.Ods.Sandbox.Admin.exe"]