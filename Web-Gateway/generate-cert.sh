#!/bin/bash

if [[ `basename "${PWD}"` == "Web-Gateway" ]];
then
    mkdir -p ssl
    openssl dhparam -out ssl/dhparam.pem 4096
    openssl req -subj '/CN=EDFI-WRK118.msdf.org:5001' -x509 -newkey rsa:4096 -nodes -keyout ssl/server.key -out ssl/server.crt -days 365
else
    echo "NOT in Gateway folder"
    exit -1
fi
