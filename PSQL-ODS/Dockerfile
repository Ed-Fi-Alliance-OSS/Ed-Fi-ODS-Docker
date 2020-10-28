FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
RUN apk update && apk upgrade && apk add unzip
ENV MINVERSION="5.1.0-b10313"
ENV POPULVERSION="5.1.0-b10284"
WORKDIR /app
RUN wget -O /app/WebApi.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Minimal.Template.PostgreSQL/${MINVERSION} && unzip /app/WebApi.zip -d /app && rm -Rf /app/WebApi.zip *.xml _rels
RUN wget -O /app/WebApi.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Populated.Template.PostgreSQL/${POPULVERSION} && unzip /app/WebApi.zip -d /app && rm -Rf /app/WebApi.zip *.xml _rels
#Need to copy *.sql files to "docker-entrypoint-initdb.d" from local machine otherwise getting errorr while copying files
COPY ./*.sql /docker-entrypoint-initdb.d/
RUN ["chmod", "+x", "/docker-entrypoint-initdb.d/"]
EXPOSE "5432"
ENTRYPOINT ["/docker-entrypoint-initdb.d/"]

