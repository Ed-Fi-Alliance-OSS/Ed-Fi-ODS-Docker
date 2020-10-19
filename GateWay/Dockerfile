FROM nginx:stable-alpine
LABEL maintainer="Ed-Fi Alliance, LLC and Contributors <techsupport@ed-fi.org>"
RUN apk update && apk upgrade
COPY edfi.conf /etc/nginx/conf.d/edfi.conf
RUN mkdir /etc/nginx/ssl
EXPOSE 80
EXPOSE 443
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]