FROM quay.io/eformat/trino-dep:413 as base
ARG HADOOP_VERSION=3.3.5
ARG METASTORE_VERSION=3.1.3
RUN mkdir -p /tmp/hive/hadoop && tar -C /tmp/hive/hadoop --strip-components=1 -xzf /root/hadoop-${HADOOP_VERSION}.tar.gz
RUN mkdir -p /tmp/hive/metastore && tar -C /tmp/hive/metastore --strip-components=1 -xzf /root/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz

# Final container image:
FROM registry.access.redhat.com/ubi8/ubi:8.7-1112

ARG HADOOP_VERSION=3.3.4
ARG METASTORE_VERSION=3.1.3
ARG PROMETHEUS_VERSION=0.18.0
ARG LOG4J_VERSION=2.19.0

ENV HADOOP_HOME=/opt/hadoop
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
ENV METASTORE_HOME=/opt/hive-metastore-bin

LABEL io.k8s.display-name="OpenShift Hive" \
      io.k8s.description="This is an image used to install and run Hive." \
      summary="This is an image used to install and run Hive." \
      io.openshift.tags="openshift"

ADD hive/postgresql-jdbc-42.3.6-1.rhel8.noarch.rpm /tmp
RUN \
    # symlink the python3.6 installed in the container
    ln -s /usr/libexec/platform-python /usr/bin/python && \
    # add PostgreSQL RPM repository to gain access to the postgres jdbc
    # yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    set -xeu && \
    # Java 1.8 required for Hive/Hadoop
    # postgresql-jdbc needed so Hive can connect to postgres
    # jq is needed for the entrypoint script to work properly
    INSTALL_PKGS="java-1.8.0-openjdk openssl jq /tmp/postgresql-jdbc-42.3.6-1.rhel8.noarch.rpm" && \
    yum install -y $INSTALL_PKGS && \
    yum -y update && \
    yum clean all && \
    rm -rf /var/cache/yum

# setup metastore home
RUN mkdir -p ${HADOOP_HOME} ${METASTORE_HOME}/conf

RUN groupadd -r metastore --gid=1000 && \
    useradd -r -g metastore --uid=1000 -d ${METASTORE_HOME} metastore

# Move the default configuration files into the container
COPY hive/conf/jmx-config.yaml ${METASTORE_HOME}/conf
COPY hive/conf/metastore-site.xml ${METASTORE_HOME}/conf
COPY hive/conf/metastore-log4j2.properties ${METASTORE_HOME}/conf
COPY hive/scripts/entrypoint.sh /entrypoint.sh
RUN chown metastore:root ${METASTORE_HOME}/conf/jmx-config.yaml \
    ${METASTORE_HOME}/conf/metastore-site.xml \
    ${METASTORE_HOME}/conf/metastore-log4j2.properties \
    /entrypoint.sh

# Fetch the compiled Hadoop and Standalone Metastore
COPY --from=base --chown=metastore:root /tmp/hive/hadoop ${HADOOP_HOME}
COPY --from=base --chown=metastore:root /tmp/hive/metastore ${METASTORE_HOME}

RUN \
    # Configure Hadoop AWS Jars to be available to hive
    ln -s ${HADOOP_HOME}/share/hadoop/tools/lib/*aws* ${METASTORE_HOME}/lib && \
    # Configure Postgesql connector jar to be available to hive
    ln -s /usr/share/java/postgresql-jdbc.jar ${METASTORE_HOME}/lib/postgresql-jdbc.jar

####### CVE-2021-44228, CVE-2021-45046, CVE-2021-45105, CVE-2021-44832 #######
RUN rm -f ${HADOOP_HOME}/share/hadoop/common/lib/slf4j-log4j12* && \
    rm -f ${METASTORE_HOME}/lib/log4j-*
COPY --from=base --chmod=544 --chown=1000:0 /root/log4j-1.2-api-${LOG4J_VERSION}.jar ${METASTORE_HOME}/lib/log4j-1.2-api-${LOG4J_VERSION}.jar 
COPY --from=base --chmod=544 --chown=1000:0 /root/log4j-api-${LOG4J_VERSION}.jar ${METASTORE_HOME}/lib/log4j-api-${LOG4J_VERSION}.jar
COPY --from=base --chmod=544 --chown=1000:0 /root/log4j-core-${LOG4J_VERSION}.jar ${METASTORE_HOME}/lib/log4j-core-${LOG4J_VERSION}.jar
COPY --from=base --chmod=544 --chown=1000:0 /root/log4j-slf4j-impl-${LOG4J_VERSION}.jar ${METASTORE_HOME}/lib/log4j-slf4j-impl-${LOG4J_VERSION}.jar
COPY --from=base --chmod=544 --chown=1000:0 /root/jmx_prometheus_javaagent-${PROMETHEUS_VERSION}.jar ${METASTORE_HOME}/lib/jmx_exporter.jar

# certs
COPY cacerts.pem /etc/pki/ca-trust/source/anchors/cacerts.pem
RUN update-ca-trust extract

RUN chown -R 1000:0 ${HOME} /etc/passwd $(readlink -f ${JAVA_HOME}/lib/security/cacerts) && \
    chmod -R 774 /etc/passwd $(readlink -f ${JAVA_HOME}/lib/security/cacerts) && \
    chmod 755 /entrypoint.sh && \
    chmod -R 775 ${HOME}

# run
USER metastore
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
