FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

ENV MINVERSION="5.1.0-b10351"
ENV POPULVERSION="5.1.0-b10337"

ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=postgres

COPY init-database.sh /docker-entrypoint-initdb.d/init-database.sh

RUN apk add unzip dos2unix && \
    wget -O /tmp/OdsMinimalDatabse.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Minimal.Template.PostgreSQL/${MINVERSION} && \
    unzip -p /tmp/OdsMinimalDatabse.zip EdFi.Ods.Minimal.Template.sql > /tmp/EdFi_Ods_Minimal_Template.sql && \
    rm -f /temp/OdsMinimalDatabse.zip && \
    wget -O /tmp/OdsPopulatedDatabse.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Populated.Template.PostgreSQL/${POPULVERSION} && \
    unzip -p /tmp/OdsPopulatedDatabse.zip EdFi.Ods.Populated.Template.sql > /tmp/EdFi_Ods_Populated_Template.sql && \
    rm -f /tmp/OdsPopulatedDatabse.zip && \
    dos2unix /docker-entrypoint-initdb.d/init-database.sh && \
    dos2unix /tmp/EdFi_Ods_Minimal_Template.sql && \
    dos2unix /tmp/EdFi_Ods_Populated_Template.sql

CMD ["docker-entrypoint.sh", "postgres"]
