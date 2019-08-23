# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

FROM alpine

RUN apk add --no-cache \
    openssl \
    git \
    openjdk8 \
    curl \
    bash \
    openssh-client \
    unzip \
    bash \
    ttf-dejavu \
    coreutils \
    iptables \
    ip6tables \
    ipset \
    iproute2 \
    python \
    py-pip \
    groff \
    less \
    mailcap

# install oc client
RUN apk add --no-cache ca-certificates wget openssl curl && update-ca-certificates && \
    curl -o glibc.apk -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.23-r1/glibc-2.23-r1.apk" && \
    apk add --allow-untrusted glibc.apk && \
    curl -o glibc-bin.apk -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.23-r1/glibc-bin-2.23-r1.apk" && \
    apk add --allow-untrusted glibc-bin.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc/usr/lib && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -f glibc.apk glibc-bin.apk 

RUN mkdir -p /tmp/oc-client && cd /tmp/oc-client && \
    wget -O oc-client.tar.gz https://github.com/openshift/origin/releases/download/v3.6.1/openshift-origin-client-tools-v3.6.1-008f2d5-linux-64bit.tar.gz && \
    tar -xvf oc-client.tar.gz && \
    mv */oc /usr/local/bin/oc

RUN wget -O get_helm.sh https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get && \
    chmod 700 ./get_helm.sh && \
    sh ./get_helm.sh --version v2.8.2 && \
    rm -rf /var/cache/apk/*