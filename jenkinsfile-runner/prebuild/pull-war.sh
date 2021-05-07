#!/bin/bash
set -xe

## runs inside jenkins/jenkins
echo "+------------+"
echo "| Pull War   |"
echo "+------------+"
## setup tmp directory to work with and update files
mkdir -p /root/prebuild/dependencies/tmp /root/prebuild/dependencies/tmp/jenkins
cp /usr/share/jenkins/jenkins.war /root/prebuild/dependencies/tmp/jenkins.war
unzip -q /root/prebuild/dependencies/tmp/jenkins.war -d /root/prebuild/dependencies/tmp/jenkins/
rm -rf \
  /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/commons-beanutils-1.9.3.jar \
  /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/commons-fileupload-1.3.1-jenkins-2.jar \
  /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/handlebars-1.1.1-core-assets.jar \
  /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/commons-jelly-tags-fmt-1.0.jar \
  /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/xstream-1.4.15.jar \
  /root/prebuild/dependencies/app/jenkins/{scripts,jsbundles,css,images,help,WEB-INF/detached-plugins,winstone.jar,WEB-INF/jenkins-cli.jar,WEB-INF/lib/jna-4.5.2.jar} \
  /root/prebuild/dependencies/app/repo/commons-beanutils/commons-beanutils/1.9.3/ \
  /root/prebuild/dependencies/app/repo/commons-fileupload/commons-fileupload/1.3.1-jenkins-2/commons-fileupload-1.3.1-jenkins-2.jar \
  /root/prebuild/dependencies/app/repo/com/thoughtworks/xstream/xstream/1.4.15 \
  /root/prebuild/dependencies/app/repo/commons-jelly/commons-jelly-tags-fmt \
  /root/prebuild/dependencies/app/repo/org/apache/maven/maven-model/3.5.4/maven-model-3.5.4.jar \

mkdir -p /root/prebuild/dependencies/app/repo/commons-beanutils/commons-beanutils/1.9.3/ \
      /root/prebuild/dependencies/app/repo/commons-fileupload/commons-fileupload/1.3.1-jenkins-2 \
      /root/prebuild/dependencies/app/repo/com/thoughtworks/xstream/xstream/1.4.15/

cp /root/prebuild/dependencies/tmp/jenkins/WEB-INF/lib/commons-beanutils-1.9.4.jar /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/commons-beanutils-1.9.4.jar
cp /root/prebuild/dependencies/tmp/jenkins/WEB-INF/lib/commons-fileupload-1.4.jar /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/commons-fileupload-1.4.jar
cp /root/prebuild/dependencies/tmp/jenkins/WEB-INF/lib/xstream-1.4.16.jar /root/prebuild/dependencies/app/jenkins/WEB-INF/lib/xstream-1.4.16.jar
cp /root/prebuild/dependencies/tmp/jenkins/winstone.jar /root/prebuild/dependencies/app/jenkins/winstone.jar
## there's something when running JFR pipelines that explicitly looks for named versions of jars, hence renaming updated versions to older versions
cp /root/prebuild/dependencies/tmp/jenkins/WEB-INF/lib/commons-beanutils-1.9.4.jar /root/prebuild/dependencies/app/repo/commons-beanutils/commons-beanutils/1.9.3/commons-beanutils-1.9.3.jar
cp /root/prebuild/dependencies/tmp/jenkins/WEB-INF/lib/commons-fileupload-1.4.jar /root/prebuild/dependencies/app/repo/commons-fileupload/commons-fileupload/1.3.1-jenkins-2/commons-fileupload-1.3.1-jenkins-2.jar
cp /root/prebuild/dependencies/tmp/jenkins/WEB-INF/lib/xstream-1.4.16.jar /root/prebuild/dependencies/app/repo/com/thoughtworks/xstream/xstream/1.4.15/xstream-1.4.15.jar
## addressing CVE-2021-26291

curl -sSLo /root/prebuild/dependencies/tmp/maven-model-3.5.4.jar https://repo1.maven.org/maven2/org/apache/maven/maven-model/3.8.1/maven-model-3.8.1.jar
mkdir /root/prebuild/dependencies/ref/plugins/pipeline-utility-steps
unzip /root/prebuild/dependencies/ref/plugins/pipeline-utility-steps.hpi -d /root/prebuild/dependencies/ref/plugins/pipeline-utility-steps
rm -rf /root/prebuild/dependencies/ref/plugins/pipeline-utility-steps.hpi \
       /root/prebuild/dependencies/ref/plugins/pipeline-utility-steps/WEB-INF/lib/maven-model-3.5.4.jar
cp /root/prebuild/dependencies/tmp/maven-model-3.5.4.jar /root/prebuild/dependencies/ref/plugins/pipeline-utility-steps/WEB-INF/lib/
mv /root/prebuild/dependencies/ref/plugins/pipeline-utility-steps /root/prebuild/dependencies/ref/plugins/pipeline-utility-steps.hpi
cp /root/prebuild/dependencies/tmp/maven-model-3.5.4.jar /root/prebuild/dependencies/app/repo/org/apache/maven/maven-model/3.5.4/
rm -rf /root/prebuild/dependencies/tmp

## update plugins
if [ -s /root/prebuild/plugins.txt ]; then
  /usr/local/bin/install-plugins.sh < /root/prebuild/plugins.txt
  sed 's/:.*//g' /root/prebuild/plugins.txt > /root/prebuild/plugs.txt
  cd /root/prebuild/dependencies/ref/plugins
  while read i; do
    rm -rf $i.hpi && mkdir -p $i.hpi
    unzip /usr/share/jenkins/ref/plugins/$i.jpi -d $i.hpi
  done < /root/prebuild/plugs.txt
  rm -f /root/prebuild/plugs.txt;
fi
