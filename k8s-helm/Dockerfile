# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

FROM centos:7
ARG HELMVERSION="v2.14.3" 
ARG KUBECTLVERSION="v1.15.3" 

RUN yum install -y wget
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTLVERSION}/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && mkdir /root/.kube

RUN wget https://storage.googleapis.com/kubernetes-helm/helm-${HELMVERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm-${HELMVERSION}-linux-amd64.tar.gz && \
    chmod +x linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm helm-${HELMVERSION}-linux-amd64.tar.gz && \
    rm -rf linux-amd64
