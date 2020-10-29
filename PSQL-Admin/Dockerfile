FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
WORKDIR /app
RUN apk update && apk upgrade
COPY ./*.sql /docker-entrypoint-initdb.d/
COPY ./*.sh /docker-entrypoint-initdb.d/
RUN ["chmod", "+x", "/docker-entrypoint-initdb.d/"]
EXPOSE "5432"
