#!/bin/sh

export GITLAB_PAT=

# Generate a new Gilab Personal Access Token
gitlab_pat() {
    # checks
    [ -z "$GIT_SERVER" ] && echo "Warning: must supply GIT_SERVER in env" && return
    [ -z "$GITLAB_USER" ] && echo "Warning: must supply GITLAB_USER in env" && return
    [ -z "$GITLAB_PASSWORD" ] && echo "Warning: must supply GITLAB_PASSWORD in env" && return
    gitlabEncodedPassword=$(echo ${GITLAB_PASSWORD} | perl -MURI::Escape -ne 'chomp;print uri_escape($_)')
    # get csrf from login page
    gitlab_basic_auth_string="Basic $(echo -n ${GITLAB_USER}:${gitlabEncodedPassword} | base64)"
    body_header=$(curl -k -L -s -H "Authorization: ${gitlab_basic_auth_string}" -c /tmp/cookies.txt -i "https://${GIT_SERVER}/users/sign_in")
    csrf_token=$(echo $body_header | perl -ne 'print "$1\n" if /new_user.*?authenticity_token"[[:blank:]]value="(.+?)"/' | sed -n 1p)
    # login
    curl -k -s -H "Authorization: ${gitlab_basic_auth_string}" -b /tmp/cookies.txt -c /tmp/cookies.txt -i "https://${GIT_SERVER}/users/auth/ldapmain/callback" \
                        --data "username=${GITLAB_USER}&password=${gitlabEncodedPassword}" \
                        --data-urlencode "authenticity_token=${csrf_token}" \
                        > /dev/null
    # generate personal access token form
    body_header=$(curl -k -L -H "Authorization: ${gitlab_basic_auth_string}" -H 'user-agent: curl' -b /tmp/cookies.txt -i "https://${GIT_SERVER}/profile/personal_access_tokens" -s)
    csrf_token=$(echo $body_header | perl -ne 'print "$1\n" if /authenticity_token"[[:blank:]]value="(.+?)"/' | sed -n 1p)
    # revoke them all 💀 !!
    revoke=$(echo $body_header | perl -nle 'print join " ", m/personal_access_tokens\/(\d+)/g;')
    if [ ! -z "$revoke" ]; then
        for x in $revoke; do
            curl -k -s -o /dev/null -L -b /tmp/cookies.txt -X POST "https://${GIT_SERVER}/profile/personal_access_tokens/$x/revoke" --data-urlencode "authenticity_token=${csrf_token}" --data-urlencode "_method=put"
        done
    fi
    # scrape the personal access token from the response
    body_header=$(curl -k -s -L -H "Authorization: ${gitlab_basic_auth_string}" -b /tmp/cookies.txt "https://${GIT_SERVER}/profile/personal_access_tokens" \
                        --data-urlencode "authenticity_token=${csrf_token}" \
                        --data 'personal_access_token[name]='"${GITLAB_USER}"'&personal_access_token[expires_at]=&personal_access_token[scopes][]=api')
    GITLAB_PAT=$(echo $body_header | perl -ne 'print "$1\n" if /created-personal-access-token"[[:blank:]]value="(.+?)"/' | sed -n 1p)    
    echo $GITLAB_PAT
}
