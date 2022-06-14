# Copyright © 2022 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.4
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Grype" \
      maintainer="uip@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="0.38.0" \
      release="0.38.0" \
      summary="Anchore Grype container" \
      description="The Anchore Grype container image for the Solutions Delivery Platform"

### add licenses to this directory
COPY LICENSE /licenses

### Use yum as root user
USER root

### Install packages
RUN INSTALL_PKGS="coreutils python3-pip jq" && \
  yum clean all &&\
  yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
  --security && \
  yum --disableplugin=subscription-manager -y install --allowerasing --setopt=tsflags=nodocs ${INSTALL_PKGS}

### Install yq
RUN python3 -m pip install --user yq

ENV PROGRAM_NAME grype
ENV PROGRAM_VERSION v0.38.0
ENV HOME /root
ENV PROGRAM_DESTINATION_DIR /usr/local/bin

ARG user=${PROGRAM_NAME}

WORKDIR /scanner

# Install Grype
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b ${PROGRAM_DESTINATION_DIR} ${PROGRAM_VERSION}

# Add user, create required directories and cleanup
RUN useradd -ms /bin/bash ${user}                                                                              && \
  chown -R ${user}:${user} ${PROGRAM_DESTINATION_DIR}/${PROGRAM_NAME}                                         && \
  mkdir /report                                                                                              && \
  chown -R ${user}:${user} /report                                                                           && \
  yum --nogpgcheck --disableplugin=subscription-manager clean all

### Insert container entrypoint script
COPY container-entrypoint.sh /usr/local/bin/container-entrypoint.sh

### Set script as executable
RUN chmod +x /usr/local/bin/container-entrypoint.sh

USER ${user}

CMD []
ENTRYPOINT [ "/bin/sh", "/usr/local/bin/container-entrypoint.sh" ]
