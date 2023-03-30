FROM quay.io/eformat/spark-base-dep:3.3.0 as base
# base spark dep in image

FROM registry.access.redhat.com/ubi8/ubi:8.6-903

ARG SPARK_VERSION=3.3.0
ARG HADOOP_VERSION=3

USER root

# Spark
COPY --from=base /root/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz /tmp/artifacts/
COPY base/modules/spark /tmp/scripts/spark

# Set 'spark' module defined environment variables
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/spark/bin" \
    SPARK_HOME="/opt/spark" \
    SPARK_INSTALL="/opt/spark-distro" 

# custom certs
COPY base/cacerts.pem /etc/pki/ca-trust/source/anchors/cacerts.pem
RUN update-ca-trust extract

ADD base/pip.conf /etc/.

# Custom scripts from 'spark' module
RUN [ "sh", "-x", "/tmp/scripts/spark/install" ]

# custom settings
COPY base/ivy-settings.xml /etc/ivy-settings.xml

# update openshift client
ENV OC_VERSION=4.11.18
RUN rm -f /usr/local/bin/oc && \
    curl -sL https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz | tar -C /usr/local/bin -xzf -
