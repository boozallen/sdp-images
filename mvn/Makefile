OWNER    = boozallen
REPO     = sdp-images
IMAGE    = mvn
VERSION  = 3.8.6-openjdk-17

REGISTRY = docker.pkg.github.com/$(OWNER)/$(REPO)
TAG      = $(REGISTRY)/$(IMAGE):$(VERSION)

.PHONY: help Makefile 
.ONESHELL: push 


# Put it first so that "make" without argument is like "make help".
help: ## Show target options
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

build: ## build container image 
	docker build --no-cache . -t $(TAG)

push: ## builds and publishes container image 
	$(eval user := $(shell read -p "GitHub Username: " username; echo $$username))
	$(eval pass := $(shell read -s -r -p "GitHub Token: " token; echo $$token))
	@echo 
	@docker login $(REGISTRY) -u $(user) -p $(pass); 
	make build 
	docker tag $(TAG) $(REGISTRY)/$(IMAGE):latest
	docker push $(TAG)
	docker push $(REGISTRY)/$(IMAGE):latest

info: 
	@echo "$(TAG) -> $$(dirname $$(git ls-files --full-name Makefile))"

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	echo "Make command $@ not found" 

