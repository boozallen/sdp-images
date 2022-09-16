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
      version="2.1.1" \
      release="2.1.1" \
      summary="Python3 Cookiecutter Library" \
      description="The Python3 Cookiecutter container image for the Solutions Delivery Platform"

### add licenses to this directory
COPY LICENSE /licenses

### Use yum as root user
USER root

WORKDIR /root

ENV PROGRAM_NAME cookiecutter
ENV PROGRAM_VERSION 2.1.1

### Add necessary Red Hat repos and packages here. cookiecutter 2.1.1 needs more recent python version.
RUN INSTALL_PKGS="coreutils python39 python39-pip git"                                                           && \
    yum clean all                                                                                                && \
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs --security                && \
    yum --disableplugin=subscription-manager -y install --allowerasing --setopt=tsflags=nodocs ${INSTALL_PKGS}   && \
    python3 -m pip install ${PROGRAM_NAME}==${PROGRAM_VERSION}                                            

### Insert Container Entry Point Script
COPY container-entrypoint.sh /usr/local/bin/container-entrypoint.sh

### Set script as executable
RUN chmod +x /usr/local/bin/container-entrypoint.sh

ENTRYPOINT [ "/bin/sh", "/usr/local/bin/container-entrypoint.sh" ]
