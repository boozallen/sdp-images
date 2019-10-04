## Note: Pulling container will require logging into Red Hat's registry using `docker login registry.redhat.io` .
#FROM registry.redhat.io/ubi7-dev-preview/ubi
#FROM docker-registry-default.apps.ocp-dev.microcaas.net/ubi/ubi7-hardened
FROM registry.access.redhat.com/ubi7
MAINTAINER Steven Terrana <terrana_steven@bah.com>

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Jenkins Agent" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="1.0" \
      release="1.0" \
      summary="An OWASP ZAP container image used by the owasp_zap library of the Solutions Delivery Platform" \
      description="An OWASP ZAP container image used by the owasp_zap library of the Solutions Delivery Platform"

### add licenses to this directory
COPY licenses /licenses

### Add necessary Red Hat repos and packages here
RUN INSTALL_PKGS="java-1.8.0-openjdk unzip python27-python-pip git openbox xterm net-tools firefox xvfb x11vnc gcc g++" && \
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

### Install your application here -- add all other necessary items to build your image

ARG user=zap
ARG group=zap
ARG uid=1000
ARG gid=1000

WORKDIR /zap

# w/ UBI - had to download RPMs from repo and install manually
# these RPM's were gotten via:
#
#
COPY rpms /zap/rpms
RUN rpm -ivh /zap/rpms/*.rpm

RUN mkdir -p /home/zap /zap && \
    chown ${uid}:${gid} /zap && \
    groupadd -g ${gid} ${group} && \
    useradd -d "/home/zap" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

COPY ZAP_2.7.0_Core.tar.gz /zap/zap.tar.gz
RUN tar -xzf /zap/zap.tar.gz -C /zap && \
    mv /zap/ZAP_2.7.0/** /zap && \
    rm -rf /zap/zap.tar.gz /zap/ZAP_2.7.0

COPY policies /home/zap/.ZAP/policies/
COPY webswing-2.5.10.zip /zap/webswing.zip
RUN unzip webswing.zip && \
    rm -rf /zap/webswing/demo /zap/webswing.zip && \
    touch /zap/AcceptedLicense

COPY webswing.config /zap/webswing/
COPY .xinitrc /home/zap/
COPY zap-x.sh /zap/zap-x.sh

RUN chown -R ${user}:${group} /zap /home/zap && \
    chmod +x /zap/zap.sh /zap/zap-x.sh && \
    printf 'pip install --upgrade zapcli python-owasp-zap-v2.4==0.0.14' | scl enable python27 - 

USER ${user}

# zap port
EXPOSE 8080 8090

ENV PATH $JAVA_HOME/bin:/zap/:$PATH
ENV ZAP_PATH /zap/zap.sh
ENV PATH /opt/rh/python27/root/usr/bin${PATH:+:${PATH}}
ENV LD_LIBRARY_PATH /opt/rh/python27/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV MANPATH /opt/rh/python27/root/usr/share/man:${MANPATH}
