#!/bin/bash

set -e

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)

if ! whoami  &>/dev/null; then
    # current user is an arbitrary
    # user (its uid is not in the
    # container /etc/passwd). Let's fix that
    cat ${HOME}/passwd.template | \
    sed "s/\${USER_ID}/${USER_ID}/g" | \
    sed "s/\${GROUP_ID}/${GROUP_ID}/g" | \
    sed "s/\${HOME}/\/home\/developer/g" > /etc/passwd

    cat ${HOME}/group.template | \
    sed "s/\${USER_ID}/${USER_ID}/g" | \
    sed "s/\${GROUP_ID}/${GROUP_ID}/g" | \
    sed "s/\${HOME}/\/home\/developer/g" > /etc/group
fi

exec "$@"