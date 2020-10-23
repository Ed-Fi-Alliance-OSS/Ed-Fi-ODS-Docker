FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
RUN apk update && apk upgrade
WORKDIR /app
ADD https://ed-fi-alliance.slack.com/files/U8QTCGJSC/F01DF8DR9LG/edfi_admin.sql /docker-entrypoint-initdb.d/
ADD https://ed-fi-alliance.slack.com/files/U8QTCGJSC/F01CRK4EU03/edfi_security.sql /docker-entrypoint-initdb.d/
RUN ["chmod", "+x", "/docker-entrypoint-initdb.d/"]
USER postgres
EXPOSE 5432
ENTRYPOINT ["/docker-entrypoint.initdb.d"]