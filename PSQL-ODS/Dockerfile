FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
RUN apk update && apk upgrade && apk add unzip
ENV MINVERSION="5.1.0-b10313"
ENV POPULVERSION="5.1.0-b10284"
WORKDIR /app
RUN wget -O /app/min.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Minimal.Template.PostgreSQL/${MINVERSION} && unzip /app/min.zip && rm -f /app/min.zip
RUN wget -O /app/popular.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Populated.Template.PostgreSQL/${POPULVERSION} && unzip /app/popular.zip && rm -f /app/popular.zip
EXPOSE 5432
RUN ["chmod", "+x", "/docker-entrypoint-initdb.d/"]
ENTRYPOINT ["/docker-entrypoint.sh"]
