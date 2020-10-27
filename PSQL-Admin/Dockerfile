FROM postgres:11-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
RUN apk update && apk upgrade && apk add unzip
WORKDIR /app
COPY *.sql /app/
USER postgres
EXPOSE 5432
CMD ["postgres","run"]
