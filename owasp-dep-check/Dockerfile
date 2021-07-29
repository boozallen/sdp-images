ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.4
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Jenkins Agent" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="6.2.2" \
      release="6.2.2" \
      summary="OWASP Dependency Check  container" \
      description="The OWASP Dependency Check container image for the Solutions Delivery Platform"

### add licenses to this directory
COPY LICENSE /licenses

### Add necessary Red Hat repos and packages here
RUN INSTALL_PKGS="java-1.8.0-openjdk-devel ruby glibc glibc-common" && \
    yum -y update-minimal --setopt=tsflags=nodocs --security  && \
    yum -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

ENV SDP_DCAR_OWASP_DEP_CHK_VERSION dcar-2.1
ENV OWASP_DEP_CHK_VERSION 6.2.2
ENV HOME /root
ENV JAVA_HOME /usr/lib/jvm/java

ARG user=dependencycheck

# Pull dependencies from sdp-images release artifacts and verify contents
RUN mkdir /root/tmp
RUN curl -sSLo /root/tmp/owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.tar.gz https://github.com/boozallen/sdp-images/releases/download/$SDP_DCAR_OWASP_DEP_CHK_VERSION/owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.tar.gz
#COPY prebuild/owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.tar.gz /root/tmp/owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.tar.gz

COPY prebuild/BAH-public.key /root/tmp/.
COPY prebuild/owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.sig /root/tmp/.
COPY prebuild/owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.sha256 /root/tmp/.

RUN cd /root/tmp/ && gpg --import BAH-public.key
RUN cd /root/tmp/ && gpg --verify owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.sig owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.tar.gz
RUN cd /root/tmp/  && echo "$(cat owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.sha256) owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.tar.gz" | sha256sum --check --status

# Unpack dependencies and install packages

RUN cd /root/tmp && tar -xzf owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.tar.gz && \
    gem install --force --local /root/tmp/dependencies/bundle-audit/*.gem --no-document --no-rdoc --no-ri && \
    rm -rf /usr/local/share/gems/gems/rubygems-update-2.7.10/test && \
    gem cleanup

RUN cd /root/tmp && rpm -ivh --replacepkgs --replacefiles --force  /root/tmp/dependencies/mono-complete/*.rpm

RUN cd /root/tmp/dependencies/owasp && \
    unzip dependency-check-${OWASP_DEP_CHK_VERSION}-release.zip    && \
    rm dependency-check-${OWASP_DEP_CHK_VERSION}-release.zip       && \
    mv dependency-check /usr/share/                                         && \
    rm -rf /root/tmp/dependencies

# Add user, create required directories  and cleanup
RUN useradd -ms /bin/bash ${user}                                           && \
    chown -R ${user}:${user} /usr/share/dependency-check                    && \
    mkdir /report                                                           && \
    chown -R ${user}:${user} /report                                        && \
    yum --nogpgcheck --disableplugin=subscription-manager clean all

### Insert Container Entry Point Script
COPY container-entrypoint.sh /usr/share/dependency-check/bin/container-entrypoint.sh

### Set script as executable
RUN chmod +x /usr/share/dependency-check/bin/container-entrypoint.sh

USER ${user}

VOLUME ["/src" "/usr/share/dependency-check/data" "/report"]
WORKDIR /src

CMD []
ENTRYPOINT [ "/bin/sh", "/usr/share/dependency-check/bin/container-entrypoint.sh" ]
