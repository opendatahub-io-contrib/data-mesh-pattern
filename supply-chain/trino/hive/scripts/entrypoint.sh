#!/bin/sh

export JMX_OPTIONS="-javaagent:${METASTORE_HOME}/lib/jmx_exporter.jar=9000:${METASTORE_HOME}/conf/jmx-config.yaml"
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.375.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-${HADOOP_VERSION}.jar
export HADOOP_OPTS="${HADOOP_OPTS} ${VM_OPTIONS} ${GC_SETTINGS} ${JMX_OPTIONS}"
export HIVE_OPTS="${HIVE_OPTS} --hiveconf metastore.root.logger=${HIVE_LOGLEVEL},console "
export PATH=${METASTORE_HOME}/bin:${HADOOP_HOME}/bin:$PATH

set -e
# add UID to /etc/passwd if missing
if ! whoami &> /dev/null; then
    if test -w /etc/passwd || stat -c "%a" /etc/passwd | grep -qE '.[267].'; then
        echo "Adding user ${USER_NAME:-hadoop} with current UID $(id -u) to /etc/passwd"
        # Remove existing entry with user first.
        # cannot use sed -i because we do not have permission to write new
        # files into /etc
        sed  "/${USER_NAME:-hadoop}:x/d" /etc/passwd > /tmp/passwd
        # add our user with our current user ID into passwd
        echo "${USER_NAME:-hadoop}:x:$(id -u):0:${USER_NAME:-hadoop} user:${HOME}:/sbin/nologin" >> /tmp/passwd
        # overwrite existing contents with new contents (cannot replace the
        # file due to permissions)
        cat /tmp/passwd > /etc/passwd
        rm /tmp/passwd
    fi
fi

set +e
if schematool -dbType postgres -info -verbose; then
    echo "Hive metastore schema verified."
else
    if schematool -dbType postgres -initSchema -verbose; then
        echo "Hive metastore schema created."
    else
        echo "Error creating hive metastore: $?"
    fi
fi
set -e

start-metastore
