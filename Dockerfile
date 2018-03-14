FROM extvos/python
MAINTAINER  "Mingcai SHEN <archsh@gmail.com>"
ENV PGADMIN_VERSION=2.1 \
    PYTHONDONTWRITEBYTECODE=1

# Install postgresql tools for backup/restore and dependencies
RUN apk add --no-cache postgresql postgresql-libs py2-psycopg2 wget curl py2-crypto\
 && cp /usr/bin/psql /usr/bin/pg_dump /usr/bin/pg_dumpall /usr/bin/pg_restore /usr/local/bin/ \
 && apk del postgresql
RUN addgroup -g 50 -S pgadmin \
    && adduser -D -S -h /home/pgadmin -s /sbin/nologin -u 1000 -G pgadmin pgadmin \
    && mkdir -p /home/pgadmin/config /home/pgadmin/storage  /var/lib/pgadmin /var/log/pgadmin \
    && chown -R 1000:50 /home/pgadmin /home/pgadmin/config /home/pgadmin/storage  /var/lib/pgadmin /var/log/pgadmin \
    && wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/source/pgadmin4-${PGADMIN_VERSION}.tar.gz -O /tmp/pgadmin4-${PGADMIN_VERSION}.tar.gz \
    && tar zxf /tmp/pgadmin4-${PGADMIN_VERSION}.tar.gz -C /home/pgadmin/ \
    && mv /home/pgadmin/pgadmin4-${PGADMIN_VERSION} /home/pgadmin/pgadmin4 \
    && rm -f /tmp/pgadmin4-${PGADMIN_VERSION}.tar.gz

COPY requirements.txt /home/pgadmin/pgadmin4/
COPY LICENSE config_distro.py /home/pgadmin/pgadmin4/web/
RUN pip install --upgrade pip \
    && pip install -r /home/pgadmin/pgadmin4/requirements.txt

EXPOSE 8080
COPY entry.sh /
USER pgadmin:pgadmin
VOLUME /pgadmin/
ENV PGADMIN_DEFAULT_EMAIL container@pgadmin.org
ENV PGADMIN_DEFAULT_PASSWORD gro.nimdagp
ENTRYPOINT ["/entry.sh"]
CMD ["/usr/bin/python", "/home/pgadmin/pgadmin4/web/pgAdmin4.py"]