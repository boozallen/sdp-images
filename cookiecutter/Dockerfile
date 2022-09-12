# Copyright © 2022 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.6-754
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Cookiecutter" \
      maintainer="uip@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="1.7.3" \
      release="1.7.3" \
      summary="Python3 Cookiecutter Library" \
      description="The Python3 Cookiecutter container image for the Solutions Delivery Platform"

### add licenses to this directory
COPY LICENSE /licenses

### Use yum as root user
USER root

ENV PROGRAM_NAME cookiecutter
ENV HOME /root
ENV PROGRAM_DESTINATION_DIR /usr/local/bin
ENV PROGRAM_VERSION 1.7.3

### Add necessary Red Hat repos and packages here
RUN INSTALL_PKGS="coreutils python3-pip "                                                                        && \
    yum clean all                                                                                                && \
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs --security                && \
    yum --disableplugin=subscription-manager -y install --allowerasing --setopt=tsflags=nodocs ${INSTALL_PKGS}   && \
    python3 -m pip install --user ${PROGRAM_NAME}==${PROGRAM_VERSION}

ARG user=${PROGRAM_NAME}

WORKDIR /cookiecutter

# Add user, create required directories  and cleanup
RUN useradd -ms /bin/bash ${user}                                                                              && \
    yum --nogpgcheck --disableplugin=subscription-manager clean all

### Insert Container Entry Point Script
COPY container-entrypoint.sh /usr/local/bin/container-entrypoint.sh

### Set script as executable
RUN chmod +x /usr/local/bin/container-entrypoint.sh

USER ${user}

ENTRYPOINT [ "/bin/sh", "/usr/local/bin/container-entrypoint.sh" ]
