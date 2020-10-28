FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
RUN apk update && apk upgrade
WORKDIR /app
#Need to copy *.sql files to "docker-entrypoint-initdb.d" from local machine otherwise getting error while copying files

COPY ./*.sql /docker-entrypoint-initdb.d/
RUN ["chmod", "+x", "/docker-entrypoint-initdb.d/"]
EXPOSE "5432"
ENTRYPOINT ["/docker-entrypoint-initdb.d/"]
