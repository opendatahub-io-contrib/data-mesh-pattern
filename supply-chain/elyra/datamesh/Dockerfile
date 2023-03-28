FROM quay.io/eformat/spark-elyra:3.3.0

USER root

# Install python packages
RUN /opt/app-root/bin/pip3 install python-pachyderm==7.4.0
RUN /opt/app-root/bin/pip3 install dbt-client==0.1.3
RUN /opt/app-root/bin/pip3 install great_expectations==0.16.1
RUN /opt/app-root/bin/pip3 install pyiceberg==0.3.0

# Image start
USER 1001
