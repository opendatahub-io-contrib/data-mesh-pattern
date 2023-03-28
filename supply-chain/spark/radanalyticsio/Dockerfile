FROM localhost/spark-base:override-me-as-buid-arg

USER root

# Install packages
RUN dnf --setopt=tsflags=nodocs install -y java-11-openjdk python38 python3-numpy \
    && rpm -q java-11-openjdk python38 python3-numpy

# Common
COPY radanalyticsio/modules/common /tmp/scripts/common
RUN [ "sh", "-x", "/tmp/scripts/common/install" ]

# Metrics
COPY radanalyticsio/modules/metrics /tmp/scripts/metrics
RUN [ "sh", "-x", "/tmp/scripts/metrics/install" ]

# Copy 's2i' module content
COPY radanalyticsio/modules/s2i /tmp/scripts/s2i
ENV STI_SCRIPTS_PATH="/usr/libexec/s2i" 
RUN [ "sh", "-x", "/tmp/scripts/s2i/install" ]

# custom
COPY base/cacerts.pem /etc/pki/ca-trust/source/anchors/cacerts.pem
RUN update-ca-trust extract
RUN pip3 install certifi
COPY base/ivy-settings.xml /etc/ivy-settings.xml

# Labels
LABEL \
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
    maintainer="admin@redhat.com" \
    sparkversion="${SPARK_VERSION}"

# Cleanup
RUN [ ! -d /tmp/scripts ] || rm -rf /tmp/scripts
RUN [ ! -d /tmp/artifacts ] || rm -rf /tmp/artifacts
RUN dnf clean all && [ ! -d /var/cache/dnf ] || rm -rf /var/cache/dnf

# Image start
USER 185
WORKDIR /tmp
ENTRYPOINT ["/entrypoint"]
CMD ["/launch.sh"]
