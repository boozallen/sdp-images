ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.6
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

### Add license file
COPY LICENSE /licenses

### Update and install required packages
RUN dnf update -y --nodocs && \
    dnf install -y java-17-openjdk-devel unzip dotnet-sdk-6.0.x86_64 && \
    dnf module install -y nodejs:16 && \
    dnf clean all && \
    npm install --global yarn && \
    rm -rf /var/cache/dnf

ENV OWASP_DEP_CHK_VERSION 7.3.0

### Download and install OWASP Dependency Check CLI tool
RUN curl -sSLo /tmp/dependency-check.zip https://github.com/jeremylong/DependencyCheck/releases/download/v$OWASP_DEP_CHK_VERSION/dependency-check-$OWASP_DEP_CHK_VERSION-release.zip && \
    cd /usr/share && \
    unzip /tmp/dependency-check.zip && \
    rm /tmp/dependency-check.zip

### Add user, create required directories and cleanup
ARG USER=depcheck
ARG GROUP=depcheck
ARG UID=1001
ARG GID=1001

RUN groupadd -r -g ${GID} ${GROUP} && \
    useradd -ms /bin/bash -u ${UID} -g ${GID} ${USER} && \
    chown -R ${UID}:${GID} /usr/share/dependency-check && \
    mkdir /report && \
    chown -R ${UID}:${GID} /report

### Insert Container Entry Point Script
COPY container-entrypoint.sh /usr/share/dependency-check/bin/container-entrypoint.sh

### Set script as executable
RUN chmod +x /usr/share/dependency-check/bin/container-entrypoint.sh

USER ${UID}

### Pull latest NVD data
RUN /usr/share/dependency-check/bin/dependency-check.sh --enableExperimental --updateonly

VOLUME ["/src", "/report"]
WORKDIR /src

CMD []
ENTRYPOINT [ "/bin/sh", "/usr/share/dependency-check/bin/container-entrypoint.sh" ]
