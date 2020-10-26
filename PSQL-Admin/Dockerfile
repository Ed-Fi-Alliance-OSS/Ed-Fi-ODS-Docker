FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
RUN apk update && apk upgrade
WORKDIR /app
COPY ./*.sql /docker-entrypoint-initdb.d/
RUN ["chmod", "+x", "/docker-entrypoint-initdb.d/"]
USER postgres
EXPOSE 5432
ENTRYPOINT ["/docker-entrypoint.initdb.d"]
