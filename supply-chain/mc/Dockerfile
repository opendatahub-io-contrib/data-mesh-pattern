FROM minio/mc

# for editing
RUN microdnf install vi tar gzip less

# add ca certs for trusted https
RUN mkdir -p /root/.mc/certs/CAs/
ADD ./cacerts.pem /root/.mc/certs/CAs/
RUN chown root:root /root/.mc/certs/CAs/cacerts.pem

# must set this for calculating a Signature AWS4-HMAC-SHA256
ENV MC_REGION="us-east-1"
