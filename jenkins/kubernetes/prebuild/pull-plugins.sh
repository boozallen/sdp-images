#!/bin/bash

/usr/local/bin/install-plugins.sh < /var/jenkins_home/tmp/plugins.txt
mkdir /var/jenkins_home/tmp/dependencies
mv /usr/share/jenkins/ref/plugins /var/jenkins_home/tmp/dependencies/
