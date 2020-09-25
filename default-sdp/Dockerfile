# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

FROM registry.access.redhat.com/ubi8/ubi:8.2

LABEL name="Solutions Delivery Platform: Default Basic SDP Image" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      summary="Default SDP container" \
      description="This container is the default container for SDP pipeline library containing some common utilities"

RUN INSTALL_PKGS="git wget make " && \
    yum -y update  && \
    yum -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

ARG user=sdpuser
ARG group=sdpuser
ARG uid=1000
ARG gid=1000
ARG SDP_HOME=/var/sdp

RUN mkdir -p $SDP_HOME \
  && chown ${uid}:${gid} $SDP_HOME \
  && groupadd -g ${gid} ${group} \
  && useradd -d "$SDP_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

USER ${user}
WORKDIR $SDP_HOME
CMD ["/bin/bash"]
