FROM owasp/dependency-check:5.2.1
LABEL maintainer "boozallen" 

COPY container-entrypoint.sh ./container-entrypoint.sh 
RUN chmod +x ./container-entrypoint.sh 

ENTRYPOINT ["./container-entrypoint.sh"]