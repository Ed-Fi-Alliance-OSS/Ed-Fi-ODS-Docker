FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"

RUN apk update && apk upgrade
COPY *.sql /tmp/
COPY init-database.sh /docker-entrypoint-initdb.d/init-database.sh
CMD ["docker-entrypoint.sh", "postgres"]