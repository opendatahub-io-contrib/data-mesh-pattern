FROM quay.io/eformat/trino-dep:413 as base
ARG TRINO_VERSION=413
RUN mkdir /tmp/trino && tar -C /tmp/trino --strip-components=1 -xzf /root/trino-server-${TRINO_VERSION}.tar.gz

# Final container image:
FROM registry.access.redhat.com/ubi8/ubi:8.7-1112

LABEL io.k8s.display-name="OpenShift Trino" \
      io.k8s.description="This is an image used to install and run Trino." \
      summary="This is an image used to install and run Trino." \
      io.openshift.tags="openshift"

RUN \
    # symlink the python3 installed in the container
    ln -s /usr/libexec/platform-python /usr/bin/python && \
    set -xeu && \
    INSTALL_PKGS="java-17-openjdk-devel less jq" && \
    yum install -y $INSTALL_PKGS --setopt=tsflags=nodocs && \
    yum -y update && \
    yum clean all && \
    rm -rf /var/cache/yum

# add user and directories
RUN \
    groupadd trino --gid 1000 && \
    useradd trino --uid 1000 --gid 1000 && \
    mkdir -p /usr/lib/trino /data/trino/{data,logs,spill} && \
    chown -R "trino:trino" /usr/lib/trino /data/trino

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.4.0.8-2.el8_6.x86_64 \
    TRINO_HOME=/etc/trino \
    TRINO_HISTORY_FILE=/data/trino/.trino_history

RUN chown -R 1000:0 ${HOME} /etc/passwd $(readlink -f ${JAVA_HOME}/lib/security/cacerts) && \
    chmod -R 774 /etc/passwd $(readlink -f ${JAVA_HOME}/lib/security/cacerts) && \
    chmod -R 775 ${HOME}

# copy artifacts
ARG PROMETHEUS_VERSION=0.18.0
ARG TRINO_VERSION=413

COPY --from=base --chown=trino:root /tmp/trino /usr/lib/trino
COPY --from=base --chown=trino:root /root/jmx_prometheus_javaagent-${PROMETHEUS_VERSION}.jar /usr/lib/trino/jmx_exporter.jar
COPY --from=base --chown=trino:root /root/trino-cli-${TRINO_VERSION}-executable.jar /usr/bin/trino
COPY trino/bin /usr/lib/trino
COPY --chown=trino:root trino/default/etc $TRINO_HOME
RUN chmod 755 /usr/lib/trino/jmx_exporter.jar /usr/bin/trino

# Remove all unused plugins
RUN find /usr/lib/trino/plugin -maxdepth 1 -type d ! \( -name plugin -o -name hive -o -name blackhole -o -name jmx -o -name memory -o -name postgresql -o -name tpcds -o -name tpch -o -name password-authenticators -o -name thrift -o -name sqlserver -o -name oracle -o -name iceberg \) -exec rm -rf {} \;

# certs
COPY cacerts.pem /etc/pki/ca-trust/source/anchors/cacerts.pem
RUN update-ca-trust extract

# run
USER trino:trino
ENV LANG en_US.UTF-8
CMD ["/usr/lib/trino/run-trino"]
