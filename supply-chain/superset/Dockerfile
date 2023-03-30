FROM registry.access.redhat.com/ubi8/python-38:1-104

# Superset version
ARG SUPERSET_VERSION=2.0.1

# Configure environment
ENV GUNICORN_BIND=0.0.0.0:8088 \
    GUNICORN_LIMIT_REQUEST_FIELD_SIZE=0 \
    GUNICORN_LIMIT_REQUEST_LINE=0 \
    GUNICORN_TIMEOUT=60 \
    GUNICORN_WORKERS=2 \
    PYTHONPATH=/etc/superset:/opt/superset/work-dir:$PYTHONPATH \
    SUPERSET_REPO=apache/incubator-superset \
    SUPERSET_VERSION=${SUPERSET_VERSION} \
    SUPERSET_HOME=/var/lib/superset \
    FLASK_APP=superset
ENV GUNICORN_CMD_ARGS="-w ${GUNICORN_WORKERS} --timeout ${GUNICORN_TIMEOUT} -b ${GUNICORN_BIND} --limit-request-line ${GUNICORN_LIMIT_REQUEST_LINE} --limit-request-field_size ${GUNICORN_LIMIT_REQUEST_FIELD_SIZE}"

USER root

COPY bin/superset-init /usr/local/bin
ADD pip.conf /etc/.

RUN mkdir /etc/superset  && \
    mkdir ${SUPERSET_HOME} && \
    chgrp -R 0 /etc/superset && chmod -R g=u /etc/superset && \
    chgrp -R 0 ${SUPERSET_HOME} && chmod -R g=u ${SUPERSET_HOME} && \
    chmod +x /usr/local/bin/superset-init && \
    chmod g=u /etc/passwd /etc/group && \
    dnf update -y && \
    dnf install -y gcc \
                gcc-c++ \
                libffi-devel \
                python38-devel \
                python38-pip \
                python38-wheel \
                openssl-devel \
                cyrus-sasl-devel \
                openldap-devel

RUN pip install --upgrade pip

RUN dnf clean all && \
    rm -rf /var/yum/cache/* && \
    pip install -v apache-superset==${SUPERSET_VERSION} \
                 sqlalchemy-trino>=0.5.0 \
                 authlib>=0.15.1 \
                 python-ldap>=3.4.3 \
                 Babel==2.12.1 \
                 cryptography==38.0.4 \
                 Werkzeug==2.0.3 \
                 flask==2.0.3 \
                 pyopenssl==22.1.0 \
                 pyhive \
                 markupsafe>=2.0.1 \
                 psycopg2>=2-2.9.5 \
                 trio_websocket>=0.9.2 \
                 wtforms==2.3.3 \
                 wtforms_ext>=0.0.5 \
                 jinja2>=3.0.1

VOLUME /etc/superset \
       /var/lib/superset

# Customization
COPY cacerts.pem /etc/pki/ca-trust/source/anchors/cacerts.pem
RUN update-ca-trust extract

# Deploy application
EXPOSE 8088
USER 185

CMD ["gunicorn", "superset.app:create_app()"]
