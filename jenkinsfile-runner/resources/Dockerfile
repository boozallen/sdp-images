FROM jenkins/jenkinsfile-runner:1.0-beta-29 as jfr
FROM maven:3.8.2 
ADD pom.xml /jenkinsfile-runner/pom.xml
RUN cd /jenkinsfile-runner && mvn clean package && mv /jenkinsfile-runner/target/appassembler /app
COPY --from=jfr /app/jenkins /app/jenkins
COPY --from=jfr /app/bin/jenkinsfile-runner-launcher /app/bin/jenkinsfile-runner-launcher
