#! /bin/bash -e

/usr/local/bin/jenkins_preboot.sh

/sbin/tini -- /usr/local/bin/jenkins.sh
