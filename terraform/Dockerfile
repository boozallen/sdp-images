# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

FROM hashicorp/terraform:light

COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh 

ENV SYSDIG_PROVIDER_VERSION=v0.2.0
RUN mkdir -p /plugins && \
    wget -O /plugins/terraform-provider-sysdig_$SYSDIG_PROVIDER_VERSION https://github.com/draios/terraform-provider-sysdig/releases/download/$SYSDIG_PROVIDER_VERSION/terraform-provider-sysdig-linux-amd64 && \
    chmod 777 /plugins/*

ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]
CMD []