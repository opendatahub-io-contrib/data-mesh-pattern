FROM elyra-base:0.2.1

USER root

# Install python packages
RUN /opt/app-root/bin/pip3 install jinja2==3.1.2
RUN /opt/app-root/bin/pip3 install certifi
RUN /opt/app-root/bin/pip3 install matplotlib numpy pandas scipy scikit-learn tensorflow minio

# Image start
USER 1001
