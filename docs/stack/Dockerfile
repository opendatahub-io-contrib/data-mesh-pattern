FROM registry.access.redhat.com/ubi8/ubi:8.7-1037 as base

USER root

# dnf repos
RUN rm -f /etc/yum.repos.d/*
ADD ubi8.repo /etc/yum.repos.d/ubi8.repo
RUN dnf install -y centos-gpg-keys --nogpgcheck && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

# rht-labs stuff
ENV ARGOCD_VERSION=2.5.5 \
    YQ_VERSION=4.30.6 \
    HELM_VERSION=3.10.3 \
    KUBESEAL_VERSION=0.19.3 \
    OC_VERSION=4.11.18 \
    TEKTON_VERSION=0.24.1 \
    JQ_VERSION=1.6 \
    CONFTEST_VERSION=0.37.0 \
    ROX_VERSION=3.73.1 \
    KUBELINTER_VERSION=0.5.1 \
    COSIGN_VERSION=1.13.11 \
    K6_VERSION=0.42.0 \
    JSONNET_VERSION=0.17.0 \
    MAVEN_VERSION=3.8.6 \
    HASHI_VAULT_VERSION=1.12.2

# this is based off of registry.redhat.io/codeready-workspaces/plugin-java8-rhel8
ENV NODEJS_VERSION=14 \
    PYTHON_VERSION="3.9" \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:/opt/app-root/src/.npm-global/bin/:/usr/lib/jvm/java-17-openjdk/bin:/usr/bin:$HOME/go/bin:$PATH \
    MAVEN_URL=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    HOME=/home/developer \
    PROJECTS=/projects \
    MAVEN_CONFIG=/projects/.m2

RUN dnf -y module reset nodejs python39 && \
    dnf -y module enable python39:${PYTHON_VERSION} nodejs:$NODEJS_VERSION && \
    dnf -y install \
      bash tar gzip unzip which findutils wget curl git procps-ng bzip2 java-17-openjdk java-17-openjdk-devel java-17-openjdk-headless python39 python39-devel python39-setuptools python39-pip nodejs npm nodejs-nodemon nss_wrapper zsh iputils bind-utils net-tools go-toolset && \
    dnf -y -q clean all && rm -rf /var/cache/yum && \
    pip3.9 install pylint && \
    pip3.9 install ansible && \
    mkdir -p ${HOME} ${PROJECTS} /usr/share/maven && \
    curl -fsSL ${MAVEN_URL} | tar -xzC /usr/share/maven --strip-components=1 && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    ln -s /usr/bin/node /usr/bin/nodejs && \
    ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python && \
    ln -s /usr/bin/pip${PYTHON_VERSION} /usr/bin/pip

FROM base

# argo
RUN curl -sL https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64 -o /usr/local/bin/argocd && \
    chmod -R 775 /usr/local/bin/argocd && \
    echo "🐙🐙🐙🐙🐙"

# kubeseal
RUN curl -sL https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz | tar --no-same-owner -xzf - -C /usr/local/bin kubeseal && \
    chmod -R 755 /usr/local/bin/kubeseal && \
    echo "🦭🦭🦭🦭🦭"

# tekton
RUN curl -sL https://mirror.openshift.com/pub/openshift-v4/clients/pipeline/${TEKTON_VERSION}/tkn-linux-amd64.tar.gz | tar --no-same-owner -xzf - -C /usr/local/bin tkn && \
    chmod -R 755 /usr/local/bin/tkn && \
    echo "🐈🐈🐈🐈🐈"

# oc client
RUN rm -f /usr/bin/oc && \
    curl -sL https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz | tar -C /usr/local/bin -xzf - && \
    echo "🐨🐨🐨🐨🐨"

# roxctl client
RUN curl -sL -o /usr/local/bin/roxctl https://mirror.openshift.com/pub/rhacs/assets/${ROX_VERSION}/bin/Linux/roxctl && \
    chmod +x /usr/local/bin/roxctl && \
    echo "🦜🦜🦜🦜🦜"

# kube-linter
RUN curl -sL https://github.com/stackrox/kube-linter/releases/download/${KUBELINTER_VERSION}/kube-linter-linux.tar.gz | tar -C /usr/local/bin -xzf - && \
    chmod +x /usr/local/bin/kube-linter && \
    echo "🐐🐐🐐🐐🐐"

# jq / yq
RUN curl -sLo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /usr/local/bin/jq && \
    curl -sLo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    echo "🦨🦨🦨🦨🦨"
 
# Conftest? This will make Gareth Happy :P
RUN curl --fail -skL https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz | tar zxf - -C /usr/local/bin conftest && \
    echo "🌲🌲🌲🌲🌲"

# helm
RUN curl -skL -o /tmp/helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -C /tmp -xzf /tmp/helm.tar.gz && \
    mv -v /tmp/linux-amd64/helm /usr/local/bin && \
    chmod -R 775 /usr/local/bin/helm && \
    rm -rf /tmp/linux-amd64 && \
    echo "⚓️⚓️⚓️⚓️⚓️"

# cosign
RUN curl -skL -o /usr/local/bin/cosign https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-amd64 && \
    chmod -R 775 /usr/local/bin/cosign && \
    echo "🔒🔒🔒🔒"

# hey
RUN curl -skL -o /usr/local/bin/hey https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64 && \
    chmod 775 /usr/local/bin/hey && \
    echo "👋👋👋"

# k6
RUN curl -skL https://github.com/grafana/k6/releases/download/v${K6_VERSION}/k6-v${K6_VERSION}-linux-amd64.tar.gz | tar zxf - -C /usr/local/bin --strip-components=1 k6-v${K6_VERSION}-linux-amd64/k6 && \
    chmod 775 /usr/local/bin/k6 && \
    echo "👋👋👋"

# jsonnet & jsonnet bundler 
RUN GO111MODULE="on" go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest && go install github.com/brancz/gojsontoyaml@latest && \
    curl -skL -o /tmp/jsonnet.tar.gz https://github.com/google/jsonnet/releases/download/v${JSONNET_VERSION}/jsonnet-bin-v${JSONNET_VERSION}-linux.tar.gz && \
    tar -C /tmp -xzf /tmp/jsonnet.tar.gz && \
    mv -v /tmp/jsonnet /usr/local/bin && \
    chmod -R 775 /usr/local/bin/jsonnet && \
    rm -rf /tmp/jsonnet* && \
    echo "🎺🎺🎺🎺"

# docsify-cli
RUN npm i -g docsify-cli && \
    echo "📚📚📚📚📚"

# hashi vault cli
RUN curl -skL https://releases.hashicorp.com/vault/${HASHI_VAULT_VERSION}/vault_${HASHI_VAULT_VERSION}_linux_amd64.zip | jar xv && \
    mv vault /usr/local/bin/vault && \
    chmod 775 /usr/local/bin/vault && \
    echo "🩳🩳🩳"

# minio client
ENV MC_REGION="us-east-1"
RUN mkdir -p /projects/.mc/certs/CAs/
ADD cacerts.pem /projects/.mc/certs/CAs/
COPY mc /usr/local/bin/mc
RUN chown -R 1001:1001 /projects/.mc

# oh-my-zsh 
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh && \
    cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc && \
    chmod 660 $HOME/.zshrc && \
    sed -i '1iZSH_DISABLE_COMPFIX=true' $HOME/.zshrc && \
    sed -i '/^# DISABLE_MAGIC_FUNCTIONS.*/s/^#//' $HOME/.zshrc && \
    echo "setopt PROMPT_CR" >> $HOME/.zshrc && \
    echo "setopt PROMPT_SP" >> $HOME/.zshrc && \
    echo "export PROMPT_EOL_MARK=\"\"" >> $HOME/.zshrc && \
    echo "😎😎😎😎😎"

# sort out git
RUN echo "git config --global http.sslVerify false" | tee -a /etc/bashrc -a /etc/zshrc && \
    echo "git config --global user.name 'Derek Dinosaur'" | tee -a /etc/bashrc -a /etc/zshrc&& \
    echo "git config --global user.email 'derek@dinosaur.com'" | tee -a /etc/bashrc -a /etc/zshrc && \
    echo "git config --global credential.helper 'cache --timeout=172800'" | tee -a /etc/bashrc -a /etc/zshrc && \
    echo "git config --global pull.rebase 'false'" | tee -a /etc/bashrc -a /etc/zshrc && \
    echo "git config --global push.default 'simple'" | tee -a /etc/bashrc -a /etc/zshrc && \
    echo "🤗🤗🤗🤗🤗"

# custom user functions
RUN echo "source /usr/local/bin/user-functions.sh" | tee -a /etc/bashrc -a /etc/zshrc

# create user && clean up
RUN rm -rf /tmp/* && \
    useradd -u 1000 -G wheel,root -d /home/developer --shell /bin/zsh -M developer && \
    for f in "${HOME}" "/etc/passwd" "/etc/group" "/projects" "${HOME}/.cache"; do \
        chgrp -R 0 ${f} && \
        chmod -R g+rwX ${f}; \
    done && \
    echo "🧹🧹🧹🧹🧹" && \
    cat /etc/passwd | \
    sed s#developer:x.*#developer:x:\${USER_ID}:\${GROUP_ID}::\${HOME}:/bin/zsh#g \
    > ${HOME}/passwd.template && \
    cat /etc/group | \
    sed s#root:x:0:#root:x:0:0,\${USER_ID}:#g \
    > ${HOME}/group.template && \
    echo "🐟🐟🐟🐟🐟"

# Prepare entrypoint
COPY root /

# runtime
USER developer
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ] 
WORKDIR /projects
