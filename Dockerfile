FROM extvos/python
MAINTAINER  "Mingcai SHEN <archsh@gmail.com>"
ENV PGADMIN_VERSION=2.1 \
    PYTHONDONTWRITEBYTECODE=1

# Install postgresql tools for backup/restore
RUN apk add --no-cache postgresql \
 && cp /usr/bin/psql /usr/bin/pg_dump /usr/bin/pg_dumpall /usr/bin/pg_restore /usr/local/bin/ \
 && apk del postgresql

RUN apk add --no-cache alpine-sdk postgresql-dev python-dev build-base\
 && pip install --upgrade pip \
 && echo "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py2.py3-none-any.whl" | pip install --no-cache-dir -r /dev/stdin \
 && apk del alpine-sdk python-dev build-base \
 && addgroup -g 50 -S pgadmin \
 && adduser -D -S -h /pgadmin -s /sbin/nologin -u 1000 -G pgadmin pgadmin \
 && mkdir -p /pgadmin/config /pgadmin/storage  /var/lib/pgadmin\
 && chown -R 1000:50 /pgadmin /pgadmin/config /pgadmin/storage  /var/lib/pgadmin

EXPOSE 8080

COPY LICENSE config_distro.py /usr/lib/python2.7/site-packages/pgadmin4/
COPY entry.sh /
USER pgadmin:pgadmin
VOLUME /pgadmin/
ENV PGADMIN_DEFAULT_EMAIL container@pgadmin.org
ENV PGADMIN_DEFAULT_PASSWORD gro.nimdagp
# CMD ["python", "./usr/lib/python2.7/site-packages/pgadmin4/pgAdmin4.py"]
# Start the service
ENTRYPOINT ["/bin/sh", "/entry.sh"]