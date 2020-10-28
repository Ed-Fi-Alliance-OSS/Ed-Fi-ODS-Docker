FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
ENV MINVERSION="5.1.0-b10313"
ENV POPULVERSION="5.1.0-b10284"
WORKDIR /app
RUN apk update && apk upgrade && apk add unzip
RUN wget -O /app/WebApi.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Minimal.Template.PostgreSQL/${MINVERSION} && unzip /app/WebApi.zip -d /app && mv /app/*.sql /docker-entrypoint-initdb.d/ && rm -Rf /app/*
RUN wget -O /app/WebApi.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Populated.Template.PostgreSQL/${POPULVERSION} && unzip /app/WebApi.zip -d /app && mv /app/*.sql /docker-entrypoint-initdb.d/ && rm -Rf /app/*

EXPOSE "5432"
