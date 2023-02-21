.DEFAULT_GOAL := help

# AutoDoc
# -------------------------------------------------------------------------
.PHONY: help
help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.DEFAULT_GOAL := help

# Docker
# -------------------------------------------------------------------------

IMAGES := $(shell find ./docker -type f -name Dockerfile -exec sh -c 'basename $$(dirname {}):$$(basename {} .Dockerfile)' \;)

.PHONY: docker-lint
lint: ## Lint all Dockerfiles
	find ./docker -type f -name Dockerfile -exec hadolint {} \;

build: ## Build all Docker images to ensure there are no errors
	find ./docker -type f -name Dockerfile -exec sh -c 'docker build -t $$(basename $$(dirname {})):$$(basename {} .Dockerfile) -f {} .' \;

scan: ## Scan all Docker images for vulnerabilities
	@for image in $(IMAGES); do \
		echo "Scanning $${image}..."; \
		trivy image --severity HIGH,CRITICAL --no-progress "$${image}"; \
	done
