FROM python:3.8.2-alpine3.11

# Versions: https://pypi.python.org/pypi/awscli#downloads
ENV AWS_CLI_VERSION 1.16.140
ENV AWS_SAM_VERSION 0.43.0

RUN apk --no-cache update && \
    apk --no-cache add --virtual builddeps ca-certificates groff less gcc musl-dev && \
    pip3 --no-cache-dir install awscli==${AWS_CLI_VERSION} && \
    pip3 --no-cache-dir install aws-sam-cli==${AWS_SAM_VERSION} && \
    apk add jq && \
    apk del builddeps && \
    rm -rf /var/cache/apk/*

WORKDIR /data