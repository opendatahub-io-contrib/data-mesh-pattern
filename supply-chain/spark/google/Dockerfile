FROM localhost/spark-base:override-me-as-buid-arg

# Build options
ARG jmx_prometheus_javaagent_version=0.17.0

# Install packages
RUN yum --setopt=tsflags=nodocs install -y java-11-openjdk python38 python3-numpy zip \
    && rpm -q java-11-openjdk python38 python3-numpy zip
RUN pip3 install --upgrade pip setuptools certifi numpy
ENV PYTHONPATH ${SPARK_HOME}/python/lib/pyspark.zip:${SPARK_HOME}/python/lib/py4j-*.zip

ARG aws_java_sdk_version=1.12.264
ARG hadoop_aws_version=3.3.3
ADD https://nexus-rainforest-ci-cd.apps.foo.sandbox1234.opentlc.com/repository/maven-public/com/amazonaws/aws-java-sdk-bundle/${aws_java_sdk_version}/aws-java-sdk-bundle-${aws_java_sdk_version}.jar /opt/spark/jars/
ADD https://nexus-rainforest-ci-cd.apps.foo.sandbox1234.opentlc.com/repository/maven-public/org/apache/hadoop/hadoop-aws/${hadoop_aws_version}/hadoop-aws-${hadoop_aws_version}.jar /opt/spark/jars/

# Prometheus and Metrics
#ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${jmx_prometheus_javaagent_version}/jmx_prometheus_javaagent-${jmx_prometheus_javaagent_version}.jar /prometheus/
ADD https://nexus-rainforest-ci-cd.apps.foo.sandbox1234.opentlc.com/repository/maven-public/io/prometheus/jmx/jmx_prometheus_javaagent/${jmx_prometheus_javaagent_version}/jmx_prometheus_javaagent-${jmx_prometheus_javaagent_version}.jar /prometheus/
RUN chmod 0644 prometheus/jmx_prometheus_javaagent*.jar
RUN mkdir -p /etc/metrics/conf
COPY google/conf/metrics.properties /etc/metrics/conf
COPY google/conf/prometheus.yaml /etc/metrics/conf

# custom settings
COPY base/ivy-settings.xml /etc/ivy-settings.xml

# Labels
LABEL \
    maintainer="admin@redhat.com" \
    sparkversion="${SPARK_VERSION}"

# Cleanup
RUN [ ! -d /tmp/scripts ] || rm -rf /tmp/scripts
RUN [ ! -d /tmp/artifacts ] || rm -rf /tmp/artifacts
RUN dnf clean all && [ ! -d /var/cache/dnf ] || rm -rf /var/cache/dnf

COPY google/conf/entrypoint /entrypoint

# Image start
USER 185
WORKDIR /tmp
ENTRYPOINT ["/entrypoint"]
