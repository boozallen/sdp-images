FROM owasp/dependency-check:5.3.2
LABEL maintainer "boozallen" 

USER root 

COPY container-entrypoint.sh container-entrypoint.sh 
RUN chmod +x container-entrypoint.sh 

ENTRYPOINT [ "/bin/sh", "/src/container-entrypoint.sh" ]
CMD []
