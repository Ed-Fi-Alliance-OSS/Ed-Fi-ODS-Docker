# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

FROM alpine:3.22

RUN apk add --no-cache bash pgbouncer && \
    adduser -D -H -s /sbin/nologin pgbouncer && \
    mkdir -p /etc/pgbouncer /var/log/pgbouncer && \
    chown -R pgbouncer:pgbouncer /etc/pgbouncer /var/log/pgbouncer

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER pgbouncer
WORKDIR /etc/pgbouncer

EXPOSE 6432

# PgBouncer configuration environment variables
ENV PGBOUNCER_PORT=6432 \
  PGBOUNCER_DATABASE="*" \
  PGBOUNCER_EXTRA_FLAGS="" \
  POSTGRESQL_PORT=5432 \
  POSTGRESQL_HOST=postgres \
  PGBOUNCER_SET_DATABASE_USER="yes" \
  PGBOUNCER_SET_DATABASE_PASSWORD="yes"

# Health check: ensure PgBouncer is listening on port 6432
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
  CMD bash -c 'timeout 1 bash -c "</dev/tcp/localhost/6432" && echo OK || exit 1'

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]
