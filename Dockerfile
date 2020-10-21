FROM mcr.microsoft.com/dotnet/core/runtime:3.1-alpine
LABEL maintainer="EdFi Innive"
WORKDIR /app
EXPOSE 443
EXPOSE 80
RUN apk update && apk upgrade && apk add zip unzip
RUN wget https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.WebApi/5.1.0-b12868
RUN mv 5.1.0-b12868 5.1.0-b12868.zip
COPY . /app
RUN chmod 777 /app
ENTRYPOINT ["/bin/sh","EdFi.Ods.WebApi.exe"]
