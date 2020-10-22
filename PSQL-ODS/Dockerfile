FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
RUN apk update && apk upgrade
ENV MINVERSION="5.1.0-b10313"
ENV POPULVERSION="5.1.0-b10284"
RUN apk update && apk upgrade && apk add unzip
WORKDIR /app/mini
RUN wget -O /app/min.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Minimal.Template.PostgreSQL/${MINVERSION} && unzip /app/min.zip && rm -f /app/min.zip
WORKDIR /app/pop
RUN wget -O /app/popular.zip https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Populated.Template.PostgreSQL/${POPULVERSION} && unzip /app/popular.zip && rm -f /app/popular.zip
#COPY /app/mini/*.sql /docker-entrypoint-initdb.d/
#COPY /app/pop/*.sql /docker-entrypoint-initdb.d/
EXPOSE 5432
RUN ["chmod", "+x", "/docker-entrypoint-initdb.d/"]
ENTRYPOINT ["/docker-entrypoint.sh"]