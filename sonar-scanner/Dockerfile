## Note: Pulling container will require logging into Red Hat's registry using `docker login registry.redhat.io` .
#FROM registry.redhat.io/ubi7-dev-preview/ubi 
#FROM docker-registry-default.apps.ocp-dev.microcaas.net/ubi/ubi7-hardened
FROM registry.access.redhat.com/ubi7:7.6
MAINTAINER Steven Terrana <terrana_steven@bah.com> 

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Jenkins Agent" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="1.0" \
      release="1.0" \
      summary="A sonar-scanner container used by the SonarQube library of the Solutions Delivery Platform" \
      description="A sonar-scanner container used by the SonarQube library of the Solutions Delivery Platform" 

### add licenses to this directory
COPY licenses /licenses

### Add necessary Red Hat repos and packages here
RUN INSTALL_PKGS="java-1.8.0-openjdk-devel curl grep sed unzip which" && \
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

### Install your application here -- add all other necessary items to build your image
ENV SONAR_RUNNER_HOME=/root/sonar-scanner-3.0.3.778-linux
ENV PATH $PATH:/root/sonar-scanner-3.0.3.778-linux/bin

WORKDIR /root

RUN curl --insecure -o ./sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778-linux.zip && \
    unzip sonarscanner.zip && \
    rm sonarscanner.zip

COPY sonar-scanner.properties ./sonar-scanner-3.0.3.778-linux/conf/sonar-scanner.properties

#   ensure Sonar uses the provided Java for must instead of a borked glibc one
RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /root/sonar-scanner-3.0.3.778-linux/bin/sonar-scanner

# Use bash if you want to run the environment from inside the shell, otherwise use the command that actually runs the underlying stuff
#CMD /bin/bash
CMD sonar-scanner
