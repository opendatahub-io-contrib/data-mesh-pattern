FROM quay.io/eformat/spark-base-dep:3.3.0 as base
# base spark dep in image

FROM quay.io/thoth-station/s2i-lab-elyra:v0.2.1

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

# Custom scripts from 'spark' module
RUN [ "sh", "-x", "/tmp/scripts/spark/install" ]

# Install packages
RUN dnf --setopt=tsflags=nodocs install -y wget java-11-openjdk python38 python3-numpy \
    && rpm -q java-11-openjdk python38 python3-numpy

# Cleanup
RUN [ ! -d /tmp/scripts/spark ] || rm -rf /tmp/scripts/spark
RUN [ ! -d /tmp/artifacts ] || rm -rf /tmp/artifacts
RUN dnf clean all && [ ! -d /var/cache/dnf ] || rm -rf /var/cache/dnf

# Ensure python is the right one
RUN alternatives --install /usr/bin/unversioned-python python /opt/app-root/bin/python3 4

# Install python packages
ADD base/pip.conf /etc/.
RUN /opt/app-root/bin/pip3 install pyspark==${SPARK_VERSION}
RUN /opt/app-root/bin/pip3 install jinja2==3.1.2
RUN /opt/app-root/bin/pip3 install certifi
RUN /opt/app-root/bin/pip3 install jupyterlab-s3-browser==0.12.0
RUN /opt/app-root/bin/pip3 install --upgrade elyra[all]==3.15.0

#enable extension
RUN /opt/app-root/bin/jupyter serverextension enable --py jupyterlab_s3_browser

# custom
COPY base/cacerts.pem /etc/pki/ca-trust/source/anchors/cacerts.pem
RUN update-ca-trust extract
RUN mkdir -p /opt/app-root/src/.m2
COPY base/settings.xml /opt/app-root/src/.m2/settings.xml
COPY base/ivy-settings.xml /etc/ivy-settings.xml
COPY base/cacerts.pem /opt/app-root/lib64/python3.8/site-packages/certifi/cacert.pem
RUN chown 1001:1001 /opt/app-root/lib64/python3.8/site-packages/certifi/cacert.pem

# custom airflow template
COPY elyra-spark/airflow_template.jinja2 /opt/app-root/lib/python3.8/site-packages/elyra/templates/airflow/airflow_template.jinja2

# patches for minio region
COPY elyra-spark/*.patch /tmp
RUN patch /opt/app-root/lib/python3.8/site-packages/elyra/util/cos.py /tmp/cos.py.patch
RUN patch /opt/app-root/lib/python3.8/site-packages/elyra/airflow/bootstrapper.py /tmp/airflow.bootstrapper.py.patch
RUN patch /opt/app-root/lib/python3.8/site-packages/elyra/kfp/bootstrapper.py /tmp/kfp.bootstrapper.py.patch

# override the default piplineoperator to download stuff from internet.
# these files are baked into the elyra rummer image used by airflow
ENV ELYRA_BOOTSTRAP_SCRIPT_URL=file:///opt/app-root/lib/python3.8/site-packages/elyra/kfp/bootstrapper.py
ENV ELYRA_REQUIREMENTS_URL=file:///elyra-deps/requirements-elyra.txt
ENV ELYRA_REQUIREMENTS_URL_PY37=file:///elyra-deps/requirements-elyra-py37.txt

# minio client
ENV MC_REGION="us-east-1"
RUN mkdir -p /opt/app-root/src/.mc/certs/CAs/
ADD base/cacerts.pem /opt/app-root/src/.mc/certs/CAs/
COPY elyra-spark/mc /opt/app-root/bin/vaulmc
RUN chown -R 1001:1001 /opt/app-root/src/.mc

# Image start
USER 1001
