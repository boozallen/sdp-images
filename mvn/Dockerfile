# Copyright © 2022 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. 
# The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.6-754

# importing Maven from public image (version available from UBI base package repos is for JDK8)
FROM maven:3.8.5-openjdk-11 as base

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

RUN dnf update -y && \
    dnf install -y java-11-openjdk java-11-openjdk-devel && \
    dnf clean all && \
    rm -rf /var/cache/dnf

ARG USER=maven \
    GROUP=maven \
    UID=1001 \
    GID=1001

ENV LANG=C.UTF-8 \
    HOME=/home/maven \
    MAVEN_HOME=/usr/share/maven \
    MAVEN_CONFIG=/home/maven/.m2 \
    MAVEN_VERSION=3.8 \
    JAVA_HOME=/usr/lib/jvm/java \
    JAVA_VENDOR=openjdk \
    JAVA_VERSION=11
ENV PATH=$JAVA_HOME/bin:$PATH

RUN mkdir -p ${MAVEN_CONFIG} && \
    groupadd -r -g ${GID} ${GROUP} && \
    useradd -r -s /sbin/nologin -u ${UID} -g ${GID} ${USER} && \
    chown -R ${UID}:${GID} ${HOME} && \
    chmod g=u ${HOME} && \
    ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn

COPY --from=base ${MAVEN_HOME} ${MAVEN_HOME}

WORKDIR ${HOME}
USER ${USER}

CMD ["mvn"]
