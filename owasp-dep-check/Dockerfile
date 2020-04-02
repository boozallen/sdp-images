FROM registry.access.redhat.com/ubi8/ubi:8.1-406

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Jenkins Agent" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="dcar-0.8" \
      release="dcar-0.8" \
      summary="OWASP Dependency Check  container" \
      description="The OWASP Dependency Check container image for the Solutions Delivery Platform"

### add licenses to this directory
COPY LICENSE /licenses

### Add necessary Red Hat repos and packages here
RUN INSTALL_PKGS="java-1.8.0-openjdk-devel ruby  unzip" && \
    yum --nogpgcheck --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --nogpgcheck  --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

ENV SDP_DCAR_OWASP_DEP_CHK_VERSION dcar-0.8
ENV OWASP_DEP_CHK_VERSION 5.3.1
ENV HOME /root
ENV JAVA_HOME /usr/lib/jvm/java

ARG user=dependencycheck

# Pull dependencies from sdp-images release artifacts and verify contents
RUN mkdir /root/tmp
RUN curl -sSLo /root/tmp/owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.tar.gz https://github.com/boozallen/sdp-images/releases/download/$SDP_DCAR_OWASP_DEP_CHK_VERSION/owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.tar.gz

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

RUN cd /root/tmp && rpm -ivh --replacepkgs --replacefiles /root/tmp/dependencies/mono-complete/*.rpm

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
 
USER ${user}

VOLUME ["/src" "/usr/share/dependency-check/data" "/report"]
WORKDIR /src

CMD ["--help"]
ENTRYPOINT ["/usr/share/dependency-check/bin/dependency-check.sh"]

