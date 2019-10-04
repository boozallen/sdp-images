## Note: Pulling container will require logging into Red Hat's registry using `docker login registry.redhat.io` .
# FROM registry.redhat.io/ubi7-dev-preview/ubi 
#FROM docker-registry-default.apps.ocp-dev.microcaas.net/ubi/ubi7-hardened
FROM registry.access.redhat.com/ubi7:7.6
MAINTAINER Steven Terrana <terrana_steven@bah.com> 

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Jenkins Agent" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="1.0" \
      release="1.0" \
      summary="A container used by the openshift library within the Solutions Delivery Platform" \
      description="A container used by the openshift library within the Solutions Delivery Platform" 

### add licenses to this directory
COPY licenses /licenses

### Add necessary Red Hat repos and packages here
RUN INSTALL_PKGS="wget openssl tar gzip" && \
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

### Install your application here -- add all other necessary items to build your image
RUN mkdir -p /tmp/oc-client && cd /tmp/oc-client && \
    wget -O oc-client.tar.gz https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    tar -xvf oc-client.tar.gz && \
    mv */oc /usr/local/bin/oc

RUN mkdir -p /tmp/helm && cd /tmp/helm && \
    wget -O get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get && \
    chmod 700 ./get_helm.sh && \
    sh ./get_helm.sh --version v2.8.2

