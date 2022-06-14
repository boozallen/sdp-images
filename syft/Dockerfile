# Copyright © 2022 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.6-754
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Syft" \
      maintainer="uip@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="0.47.0" \
      release="0.47.0" \
      summary="Anchore Syft container" \
      description="The Anchore Syft container image for the Solutions Delivery Platform"

### add licenses to this directory
COPY LICENSE /licenses

### Use yum as root user
USER root

### Add necessary Red Hat repos and packages here
RUN INSTALL_PKGS="coreutils python3-pip jq" && \
    yum clean all && \
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs --security  && \
    yum --disableplugin=subscription-manager -y install --allowerasing --setopt=tsflags=nodocs ${INSTALL_PKGS}

ENV PROGRAM_NAME syft
ENV HOME /root
ENV PROGRAM_DESTINATION_DIR /usr/local/bin
ENV PROGRAM_VERSION v0.47.0

ARG user=${PROGRAM_NAME}

WORKDIR /scanner

# Install Syft
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b ${PROGRAM_DESTINATION_DIR} ${PROGRAM_VERSION}


# Add user, create required directories  and cleanup
RUN useradd -ms /bin/bash ${user}                                                                              && \
    chown -R ${user}:${user} ${PROGRAM_DESTINATION_DIR}/${PROGRAM_NAME}                                        && \
    mkdir /report                                                                                              && \
    chown -R ${user}:${user} /report                                                                           && \
    yum --nogpgcheck --disableplugin=subscription-manager clean all

### Insert Container Entry Point Script
COPY container-entrypoint.sh /usr/local/bin/container-entrypoint.sh

### Set script as executable
RUN chmod +x /usr/local/bin/container-entrypoint.sh

USER ${user}

CMD []
ENTRYPOINT [ "/bin/sh", "/usr/local/bin/container-entrypoint.sh" ]
