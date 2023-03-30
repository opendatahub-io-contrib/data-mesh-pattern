FROM registry.access.redhat.com/ubi8/python-38:override-me-as-buid-arg

COPY base/pip.conf /etc/pip.conf

USER 1001

RUN pip install --upgrade pip
RUN pip install certifi

USER root
COPY base/cacerts.pem /opt/app-root/lib64/python3.8/site-packages/certifi/cacert.pem
RUN chown 1001:1001 /opt/app-root/lib64/python3.8/site-packages/certifi/cacert.pem
