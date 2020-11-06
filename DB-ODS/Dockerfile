FROM postgres:11.5-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
ENV MINVERSION="5.1.0-b10313"
ENV POPULVERSION="5.1.0-b10284"
WORKDIR /app
RUN apk update && apk upgrade && apk add unzip
RUN wget -O /app/WebApi.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Minimal.Template.PostgreSQL/${MINVERSION} && unzip -p /app/WebApi.zip EdFi.Ods.Minimal.Template.sql > /app/EdFi.Ods.Minimal.Template.sql && rm -f /app/WebApi.zip
RUN wget -O /app/WebApi.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Populated.Template.PostgreSQL/${POPULVERSION} && unzip -p /app/WebApi.zip EdFi.Ods.Populated.Template.sql > /app/EdFi.Ods.Populated.Template.sql && rm -f /app/WebApi.zip
COPY ./init-database.sh /docker-entrypoint-initdb.d/
EXPOSE "5432"
#CMD ["docker-entrypoint.sh", "postgres"]

EXPOSE 5432
