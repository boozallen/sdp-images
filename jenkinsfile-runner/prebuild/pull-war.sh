#!/bin/bash
set -xe

## runs inside jenkins/jenkins
echo "+------------+"
echo "| Pull War   |"
echo "+------------+"

mkdir -p /root/prebuild/dependencies/tmp /root/prebuild/dependencies/tmp/jenkins
cp /usr/share/jenkins/jenkins.war /root/prebuild/dependencies/tmp/jenkins.war
unzip -q /root/prebuild/dependencies/tmp/jenkins.war -d /root/prebuild/dependencies/tmp/jenkins/
rm -rf \
  /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/commons-beanutils-1.9.3.jar \
  /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/commons-fileupload-1.3.1-jenkins-2.jar \
  /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/handlebars-1.1.1-core-assets.jar \
  /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/commons-jelly-tags-fmt-1.0.jar \
  /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/xstream-1.4.15.jar \
  /root/prebuild/dependencies/app/jenkins/{scripts,jsbundles,css,images,help,WEB-INF/detached-plugins,winstone.jar,WEB-INF/jenkins-cli.jar,WEB-INF/lib/jna-4.5.2.jar}

mv /root/prebuild/dependencies/tmp/jenkins/WEB-INF/lib/commons-beanutils-1.9.4.jar /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/commons-beanutils-1.9.4.jar
mv /root/prebuild/dependencies/tmp/jenkins/WEB-INF/lib/commons-fileupload-1.4.jar /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/commons-fileupload-1.4.jar
mv /root/prebuild/dependencies/tmp/jenkins/WEB-INF/lib/xstream-1.4.16.jar /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/xstream-1.4.16.jar
mv /root/prebuild/dependencies/tmp/jenkins/winstone.jar /root/prebuild/dependencies/app/jenkins/winstone.jar
rm -rf /root/prebuild/dependencies/tmp

if [ -s /root/prebuild/plugins.txt ]; then 
  /usr/local/bin/install-plugins.sh < /root/prebuild/plugins.txt
  sed 's/:.*//g' /root/prebuild/plugins.txt > /root/prebuild/plugs.txt
  cd /root/prebuild/dependencies/ref/plugins
  while read i; do 
    rm -rf $i.hpi && mkdir -p $i.hpi
    unzip /usr/share/jenkins/ref/plugins/$i.jpi -d $i.hpi;
  done < /root/prebuild/plugs.txt
  rm -f /root/prebuild/plugs.txt; 
fi
