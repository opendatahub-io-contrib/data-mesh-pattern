# trino-certs

Trino requires TLS, SSL certificates when you enable LDAPS and OAUTH authentication.

We are using a self-signed certificate for now. 

To generate (make sure your CA and Server crt have different CN's!):

```bash
openssl genrsa -aes256 -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -days 100000 -out ca.crt -subj "/CN=trino/OU=AU"
cat >server.conf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
[EXT]
subjectAltName=DNS:trino.svc,DNS:trino-service,DNS:trino-service.daintree-dev.svc.cluster.local,DNS:127.0.0.1
EOF
openssl genrsa -aes256 -out server.key 4096
openssl req -new -key server.key -out server.csr -subj "/CN=trino" -config server.conf
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 100000 -extensions v3_req -extfile server.conf -extensions EXT
```

We need a fullchain cert for our Keystore:

```bash
cat ca.crt server.crt > server.pem
openssl pkcs12 -export -in server.pem -inkey server.key -out server.p12
keytool -importkeystore -deststorepass password -destkeystore keystore.jks -srckeystore server.p12 -srcstoretype PKCS12
```

Verify the CA and Server cert:

```bash
openssl verify -verbose -CAfile ca.crt server.crt
```

Create in OpenShift for testing (this is done via gitops/hashi-vault in practice):

```bash
oc create secret generic keystore --from-file=keystore.jks
```

Get local cluster cacerts we need to trust:

```bash
oc -n ipa port-forward svc/ipa 636:636
openssl s_client -showcerts -connect localhost:636 </dev/null 2>/dev/null | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print $0}' > /tmp/ipa.pem
openssl s_client -showcerts -connect api.foo.sandbox1234.opentlc.com:6443 </dev/null 2>/dev/null | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/ {print $0}' > /tmp/oc.pem
# add to image cacerts.pem
cat /tmp/ipa.pem > ../cacerts.pem
cat /tmp/oc.pem >> ../cacerts.pem
# add to truststore
keytool -import -alias oc -file /tmp/oc.pem -keystore truststore.jks -storepass password
keytool -import -alias ipa -file /tmp/ipa.pem -keystore truststore.jks -storepass password
```

Add `ca.crt` to `superset` Image.

```bash
cat ca.crt > ../../superset/cacerts.pem
```
