# Copyright © 2023 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

FROM ghcr.io/boozallen/sdp-images/nvm:1.0.0

SHELL ["/bin/bash", "-c"]
ARG CHROME_VERSION=102.0.5005.61

# install unzip, wget
RUN dnf update -y --nodocs && \
  dnf install -y --nodocs unzip wget

# install chromedriver
RUN wget https://chromedriver.storage.googleapis.com/${CHROME_VERSION}/chromedriver_linux64.zip && \
  unzip chromedriver_linux64.zip && \
  mv chromedriver /usr/bin

# setup repos needed for installing chrome dependencies
COPY centos.repo /etc/yum.repos.d/

# import chrome signing key
RUN wget https://dl.google.com/linux/linux_signing_key.pub && \
  rpm --import linux_signing_key.pub

# install chrome
RUN wget https://dl.google.com/linux/chrome/rpm/stable/x86_64/google-chrome-stable-${CHROME_VERSION}-1.x86_64.rpm && \
  dnf -y install google-chrome-stable-${CHROME_VERSION}-1.x86_64.rpm

# install cypress dependencies (https://docs.cypress.io/guides/continuous-integration/introduction#Dependencies)
RUN dnf install -y xorg-x11-server-Xvfb gtk2-devel gtk3-devel libnotify-devel GConf2 nss libXScrnSaver alsa-lib

# cleanup
RUN rm -f /tmp/chromedriver.zip linux_signing_key.pub google-chrome-stable-${CHROME_VERSION}-1.x86_64.rpm && \
  dnf clean all && \
  rm -rf /var/cache/*

CMD ["/bin/bash"]
