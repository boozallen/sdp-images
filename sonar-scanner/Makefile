OWNER    = boozallen
REPO     = sdp-images
IMAGE    = sonar-scanner
VERSION  = 4.5.0.2216

REGISTRY = docker.pkg.github.com/$(OWNER)/$(REPO)
TAG      = $(REGISTRY)/$(IMAGE):$(VERSION)

.PHONY: help Makefile
.ONESHELL: push


# Put it first so that "make" without argument is like "make help".
help: ## Show target options
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'


build: ## build container image
	docker build . -t $(TAG) --no-cache

push: ## builds and publishes container image
	$(eval user := $(shell read -p "GitHub Username: " username; echo $$username))
	$(eval pass := $(shell read -s -r -p "GitHub Token: " token; echo $$token))
	@echo
	@docker login $(REGISTRY) -u $(user) -p $(pass);
	make build
	docker push $(TAG)

build-dep: ## build container dependencies
	$(eval dir := $(shell pwd))
	docker run -u root -it -v $(dir)/prebuild:/root/prebuild:z registry.access.redhat.com/ubi8/ubi:8.3 /root/prebuild/pull-from-ubi.sh
	docker run -u root -it -v $(dir)/prebuild:/root/prebuild:z registry.access.redhat.com/ubi8/ubi:8.3 /root/prebuild/build-dep.sh

info:
	@echo "$(TAG) -> $$(dirname $$(git ls-files --full-name Makefile))"

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	echo "Make command $@ not found"
