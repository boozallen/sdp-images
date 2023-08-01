# Copyright © 2023 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

FROM ghcr.io/boozallen/sdp-images/nvm:1.0.0

RUN dnf update -y --nodocs && \
  dnf install -y --nodocs python3 make gcc gcc-c++ && \
  dnf clean all && \
  rm -rf /var/cache/*

CMD ["/bin/bash"]