FROM quay.io/thoth-station/s2i-lab-elyra:v0.1.5

USER root

# Install packages
RUN dnf --setopt=tsflags=nodocs install -y wget java-11-openjdk python38 python3-numpy \
    && rpm -q java-11-openjdk python38 python3-numpy

# Cleanup
RUN [ ! -d /tmp/scripts ] || rm -rf /tvmp/scripts
RUN [ ! -d /tmp/artifacts ] || rm -rf /tmp/artifacts
RUN dnf clean all && [ ! -d /var/cache/dnf ] || rm -rf /var/cache/dnf

# Ensure python is the right one
RUN alternatives --install /usr/bin/unversioned-python python /opt/app-root/bin/python3 4

# Install python packages
ADD base/0.1.5/pip.conf /etc/.
RUN /opt/app-root/bin/pip3 install jinja2==3.1.2
RUN /opt/app-root/bin/pip3 install certifi
RUN /opt/app-root/bin/pip3 install jupyterlab-s3-browser
RUN /opt/app-root/bin/pip3 install great_expectations==0.15.15

#enable extension
RUN jupyter serverextension enable --py jupyterlab_s3_browser

# custom
COPY base/0.1.5/cacerts.pem /etc/pki/ca-trust/source/anchors/cacerts.pem
RUN update-ca-trust extract
RUN mkdir -p /opt/app-root/src/.m2
COPY base/0.1.5/settings.xml /opt/app-root/src/.m2/settings.xml
COPY base/0.1.5/ivy-settings.xml /etc/ivy-settings.xml
COPY base/0.1.5/cacerts.pem /opt/app-root/lib64/python3.8/site-packages/certifi/cacert.pem
RUN chown 1001:1001 /opt/app-root/lib64/python3.8/site-packages/certifi/cacert.pem
COPY base/0.1.5/airflow_template.jinja2 /opt/app-root/lib/python3.8/site-packages/elyra/templates/airflow/airflow_template.jinja2

# patches for minio region
COPY base/0.1.5/*.patch /tmp
RUN patch /opt/app-root/lib/python3.8/site-packages/elyra/util/cos.py /tmp/cos.py.patch
RUN patch /opt/app-root/lib/python3.8/site-packages/elyra/airflow/bootstrapper.py /tmp/airflow.bootstrapper.py.patch
RUN patch /opt/app-root/lib/python3.8/site-packages/elyra/kfp/bootstrapper.py /tmp/kfp.bootstrapper.py.patch

# override the default piplineoperator to download stuff from internet.
# these files are baked into the elyra rummer image used by airflow
# https://github.com/elyra-ai/elyra/blob/main/elyra/kfp/operator.py
ENV ELYRA_BOOTSTRAP_SCRIPT_URL=file:///opt/app-root/lib/python3.8/site-packages/elyra/kfp/bootstrapper.py
ENV ELYRA_REQUIREMENTS_URL=file:///elyra-deps/requirements-elyra.txt
ENV ELYRA_REQUIREMENTS_URL_PY37=file:///elyra-deps/requirements-elyra-py37.txt

# minio client
ENV MC_REGION="us-east-1"
RUN mkdir -p /opt/app-root/src/.mc/certs/CAs/
ADD base/0.1.5/cacerts.pem /opt/app-root/src/.mc/certs/CAs/
COPY base/0.1.5/mc /opt/app-root/bin/mc
RUN chown -R 1001:1001 /opt/app-root/src/.mc

# update openshift client
ENV OC_VERSION=4.11.18
RUN rm -f /opt/app-root/bin/oc && \
    curl -sL https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz | tar -C /opt/app-root/bin -xzf -

# Image start
USER 1001
