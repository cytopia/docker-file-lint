ifneq (,)
.error This Makefile requires GNU Make.
endif

# Ensure additional Makefiles are present
MAKEFILES = Makefile.docker Makefile.lint
$(MAKEFILES): URL=https://raw.githubusercontent.com/devilbox/makefiles/master/$(@)
$(MAKEFILES):
	@if ! (curl --fail -sS -o $(@) $(URL) || wget -O $(@) $(URL)); then \
		echo "Error, curl or wget required."; \
		echo "Exiting."; \
		false; \
	fi
include $(MAKEFILES)

# Set default Target
.DEFAULT_GOAL := help


# -------------------------------------------------------------------------------------------------
# Default configuration
# -------------------------------------------------------------------------------------------------
# Own vars
TAG        = latest

# Makefile.docker overwrites
NAME       = file-lint
VERSION    = latest
IMAGE      = cytopia/file-lint
FLAVOUR    = latest
FILE       = Dockerfile.${FLAVOUR}
DIR        = Dockerfiles

# Building from master branch: Tag == 'latest'
ifeq ($(strip $(TAG)),latest)
	ifeq ($(strip $(VERSION)),latest)
		DOCKER_TAG = $(FLAVOUR)
	else
		ifeq ($(strip $(FLAVOUR)),latest)
			DOCKER_TAG = $(VERSION)
		else
			DOCKER_TAG = $(FLAVOUR)-$(VERSION)
		endif
	endif
# Building from any other branch or tag: Tag == '<REF>'
else
	ifeq ($(strip $(FLAVOUR)),latest)
		DOCKER_TAG = $(VERSION)-$(TAG)
	else
		DOCKER_TAG = $(FLAVOUR)-$(VERSION)-$(TAG)
	endif
endif

# Makefile.lint overwrites
FL_IGNORES  = .git/,.github/,tests/
SC_IGNORES  = .git/,.github/,tests/
JL_IGNORES  = .git/,.github/


# -------------------------------------------------------------------------------------------------
#  Default Target
# -------------------------------------------------------------------------------------------------
.PHONY: help
help:
	@echo "lint                                     Lint project files and repository"
	@echo
	@echo "build [ARCH=...] [TAG=...]               Build Docker image"
	@echo "rebuild [ARCH=...] [TAG=...]             Build Docker image without cache"
	@echo "push [ARCH=...] [TAG=...]                Push Docker image to Docker hub"
	@echo
	@echo "manifest-create [ARCHES=...] [TAG=...]   Create multi-arch manifest"
	@echo "manifest-push [TAG=...]                  Push multi-arch manifest"
	@echo
	@echo "test [ARCH=...]                          Test built Docker image"
	@echo


# -------------------------------------------------------------------------------------------------
#  Docker Targets
# -------------------------------------------------------------------------------------------------
.PHONY: build
build: ARGS=--build-arg VERSION=$(VERSION)
build: docker-arch-build

.PHONY: rebuild
rebuild: ARGS=--build-arg VERSION=$(VERSION)
rebuild: docker-arch-rebuild

.PHONY: push
push: docker-arch-push


# -------------------------------------------------------------------------------------------------
#  Manifest Targets
# -------------------------------------------------------------------------------------------------
.PHONY: manifest-create
manifest-create: docker-manifest-create

.PHONY: manifest-push
manifest-push: docker-manifest-push


# -------------------------------------------------------------------------------------------------
#  Test Targets
# -------------------------------------------------------------------------------------------------
.PHONY: test
test: _test-req
test: _test-run-succ
test: _test-run-fail

_test-req:
	@echo "------------------------------------------------------------"
	@echo "- Testing requirements"
	@echo "------------------------------------------------------------"
	docker run --rm --platform $(ARCH) $(IMAGE):$(DOCKER_TAG) file-empty --info
	docker run --rm --platform $(ARCH) $(IMAGE):$(DOCKER_TAG) file-cr --info
	docker run --rm --platform $(ARCH) $(IMAGE):$(DOCKER_TAG) file-crlf --info
	docker run --rm --platform $(ARCH) $(IMAGE):$(DOCKER_TAG) file-nullbyte --info
	docker run --rm --platform $(ARCH) $(IMAGE):$(DOCKER_TAG) file-trailing-newline --info
	docker run --rm --platform $(ARCH) $(IMAGE):$(DOCKER_TAG) file-trailing-single-newline --info
	docker run --rm --platform $(ARCH) $(IMAGE):$(DOCKER_TAG) file-trailing-space --info
	docker run --rm --platform $(ARCH) $(IMAGE):$(DOCKER_TAG) file-utf8 --info
	docker run --rm --platform $(ARCH) $(IMAGE):$(DOCKER_TAG) file-utf8-bom --info
	docker run --rm --platform $(ARCH) $(IMAGE):$(DOCKER_TAG) git-conflicts --info

_test-run-succ:
	@echo "------------------------------------------------------------"
	@echo "- Runtime test: False positives"
	@echo "------------------------------------------------------------"
	@docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE):$(DOCKER_TAG) file-empty --path .
	@docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE):$(DOCKER_TAG) file-cr --path .
	@docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE):$(DOCKER_TAG) file-crlf --path .
	@docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE):$(DOCKER_TAG) file-nullbyte --path .
	@docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE):$(DOCKER_TAG) file-trailing-newline --path .
	@docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE):$(DOCKER_TAG) file-trailing-single-newline --path .
	@docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE):$(DOCKER_TAG) file-trailing-space --path .
	@docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE):$(DOCKER_TAG) file-utf8 --path .
	@docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE):$(DOCKER_TAG) file-utf8-bom --path .
	@docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE):$(DOCKER_TAG) git-conflicts --path .

_test-run-fail:
	@echo "------------------------------------------------------------"
	@echo "- Runtime test: True flaws"
	@echo "------------------------------------------------------------"
	@if docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/err:/data $(IMAGE):$(DOCKER_TAG) file-empty --path .; then \
		exit 1; \
	fi
	@if docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/err:/data $(IMAGE):$(DOCKER_TAG) file-cr --path .; then \
		exit 1; \
	fi
	@if docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/err:/data $(IMAGE):$(DOCKER_TAG) file-crlf --path .; then \
		exit 1; \
	fi
	@if docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/err:/data $(IMAGE):$(DOCKER_TAG) file-nullbyte --path .; then \
		exit 1; \
	fi
	@if docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/err:/data $(IMAGE):$(DOCKER_TAG) file-trailing-newline --path .; then \
		exit 1; \
	fi
	@if docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/err:/data $(IMAGE):$(DOCKER_TAG) file-trailing-single-newline --path .; then \
		exit 1; \
	fi
	@if docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/err:/data $(IMAGE):$(DOCKER_TAG) file-trailing-space --path .; then \
		exit 1; \
	fi
	@if docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/err:/data $(IMAGE):$(DOCKER_TAG) file-utf8 --path .; then \
		exit 1; \
	fi
	@if docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/err:/data $(IMAGE):$(DOCKER_TAG) file-utf8-bom --path .; then \
		exit 1; \
	fi
	@if docker run --rm --platform $(ARCH) -v $(CURRENT_DIR)/tests/err:/data $(IMAGE):$(DOCKER_TAG) git-conflicts --path .; then \
		exit 1; \
	fi
