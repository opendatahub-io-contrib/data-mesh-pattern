FROM quay.io/eformat/elyra-base:0.2.1

USER root

# Install python packages
RUN /opt/app-root/bin/pip3 install python-pachyderm==7.4.0
RUN /opt/app-root/bin/pip3 install dbt-client==0.1.3
RUN /opt/app-root/bin/pip3 install dbt-trino==1.5.0
RUN /opt/app-root/bin/pip3 install great_expectations==0.16.1
RUN /opt/app-root/bin/pip3 install pyiceberg==0.3.0
RUN /opt/app-root/bin/pip3 install trino==0.326.0
RUN /opt/app-root/bin/pip3 install sqlalchemy==2.0.16
RUN /opt/app-root/bin/pip3 install sqlalchemy-trino==0.5.0
RUN /opt/app-root/bin/pip3 install pyarrow==12.0.0
RUN /opt/app-root/bin/pip3 install fastparquet==2023.4.0
RUN /opt/app-root/bin/pip3 install python-dotenv==1.0.0

# Image start
USER 1001
