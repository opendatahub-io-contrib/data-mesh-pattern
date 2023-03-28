#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Airflow environment variables
. /opt/app-root/scripts/airflow/airflow-env.sh

# Load libraries
. /opt/app-root/scripts/airflow/libairflow.sh

if ! am_i_root && [[ -e "$LIBNSS_WRAPPER_PATH" ]]; then
    info "Enabling non-root system user with nss_wrapper"
    echo "default:x:$(id -u):$(id -g):Airflow:$AIRFLOW_HOME:/bin/false" > "$NSS_WRAPPER_PASSWD"
    echo "default:x:$(id -g):" > "$NSS_WRAPPER_GROUP"

    export LD_PRELOAD="$LIBNSS_WRAPPER_PATH"
fi

# Install custom python package if requirements.txt is present
if [[ -f "/opt/app-root/requirements.txt" ]]; then
    . /opt/app-root/bin/activate
    pip install -r /opt/app-root/requirements.txt
    deactivate
fi

if [[ "$*" = *"/opt/app-root/scripts/airflow/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Airflow setup **"
    /opt/app-root/scripts/postgresql-client/setup.sh
    /opt/app-root/scripts/airflow/setup.sh
    info "** Airflow setup finished! **"
fi

echo ""
exec "$@"
