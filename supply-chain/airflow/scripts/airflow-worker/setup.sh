#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Airflow environment variables
. /opt/app-root/scripts/airflow-worker/airflow-worker-env.sh

# Load libraries
. /opt/app-root/scripts/common/libos.sh
. /opt/app-root/scripts/common/libfs.sh
. /opt/app-root/scripts/airflow-worker/libairflowworker.sh

# Ensure Airflow environment variables settings are valid
airflow_worker_validate
# Ensure Airflow daemon user exists when running as root
am_i_root && ensure_user_exists "$AIRFLOW_DAEMON_USER" --group "$AIRFLOW_DAEMON_GROUP"
# Ensure Airflow is initialized
airflow_worker_initialize
