FROM registry.access.redhat.com/ubi8/ubi:latest

EXPOSE 8585

RUN dnf -y install wget curl java-11-openjdk-headless \
  && dnf clean all

COPY metadata/openmetadata-start.sh metadata/openmetadata.yaml ./
RUN wget https://github.com/open-metadata/OpenMetadata/releases/download/1.1.7-release/openmetadata-1.1.7.tar.gz && \
    tar zxvf openmetadata-*.tar.gz && \
    rm openmetadata-*.tar.gz
RUN chmod 755 openmetadata-start.sh
CMD ["./openmetadata-start.sh"]
