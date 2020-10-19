#!/bin/bash
openssl dhparam -out ssl/dhparam.pem 4096
openssl req -x509 -newkey rsa:4096 -nodes -keyout ssl/server.key -out ssl/server.crt -days 365