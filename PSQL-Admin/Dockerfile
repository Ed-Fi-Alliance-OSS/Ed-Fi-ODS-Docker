FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
RUN apk update && apk upgrade && apk add unzip
WORKDIR /app
#COPY ./*.sql .
RUN wget https://ed-fi-alliance.slack.com/files/U8QTCGJSC/F01DF8DR9LG/edfi_admin.sql
RUN wget  https://ed-fi-alliance.slack.com/files/U8QTCGJSC/F01CRK4EU03/edfi_security.sql
USER postgres
EXPOSE 5432
CMD ["postgres","run"]
