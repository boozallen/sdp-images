FROM centos:7

RUN yum install -y \
	openssl \
	openscap \
	openscap-utils \
	openscap-engine-sce \
    scap-security-guide \
	wget \
	which

ADD ./oscap-docker /usr/local/bin/oscap-docker


