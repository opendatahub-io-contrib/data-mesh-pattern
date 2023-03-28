#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/app-root/scripts/postgresql-client/libpostgresqlclient.sh

# Load PostgreSQL Client environment variables
. /opt/app-root/scripts/postgresql-client/postgresql-client-env.sh

# Ensure PostgreSQL Client environment variables settings are valid
postgresql_client_validate
# Ensure PostgreSQL Client is initialized
postgresql_client_initialize
