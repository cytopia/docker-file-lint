ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: build rebuild test _test_req _test_run_succ _test_run_fail tag pull login push enter

CURRENT_DIR = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

DIR = .
FILE = Dockerfile
IMAGE = cytopia/file-lint
TAG = latest

build:
	docker build -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)

rebuild: pull
	docker build --no-cache -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)

test:
	@$(MAKE) --no-print-directory _test_req
	@$(MAKE) --no-print-directory _test_run_succ
	@$(MAKE) --no-print-directory _test_run_fail

_test_req:
	@echo "------------------------------------------------------------"
	@echo "- Testing requirements"
	@echo "------------------------------------------------------------"
	@docker run --rm $(IMAGE) file-empty --info
	@docker run --rm $(IMAGE) file-cr --info
	@docker run --rm $(IMAGE) file-crlf --info
	@docker run --rm $(IMAGE) file-nullbyte --info
	@docker run --rm $(IMAGE) file-trailing-newline --info
	@docker run --rm $(IMAGE) file-trailing-single-newline --info
	@docker run --rm $(IMAGE) file-trailing-space --info
	@docker run --rm $(IMAGE) file-utf8 --info
	@docker run --rm $(IMAGE) file-utf8-bom --info

_test_run_succ:
	@echo "------------------------------------------------------------"
	@echo "- Runtime test: False positives"
	@echo "------------------------------------------------------------"
	@docker run --rm -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE) file-empty --path .
	@docker run --rm -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE) file-cr --path .
	@docker run --rm -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE) file-crlf --path .
	@docker run --rm -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE) file-nullbyte --path .
	@docker run --rm -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE) file-trailing-newline --path .
	@docker run --rm -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE) file-trailing-single-newline --path .
	@docker run --rm -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE) file-trailing-space --path .
	@docker run --rm -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE) file-utf8 --path .
	@docker run --rm -v $(CURRENT_DIR)/tests/ok:/data $(IMAGE) file-utf8-bom --path .

_test_run_fail:
	@echo "------------------------------------------------------------"
	@echo "- Runtime test: True flaws"
	@echo "------------------------------------------------------------"
	@if docker run --rm -v $(CURRENT_DIR)/tests/err:/data $(IMAGE) file-empty --path .; then \
		exit 1; \
	fi
	@if docker run --rm -v $(CURRENT_DIR)/tests/err:/data $(IMAGE) file-cr --path .; then \
		exit 1; \
	fi
	@if docker run --rm -v $(CURRENT_DIR)/tests/err:/data $(IMAGE) file-crlf --path .; then \
		exit 1; \
	fi
	@if docker run --rm -v $(CURRENT_DIR)/tests/err:/data $(IMAGE) file-nullbyte --path .; then \
		exit 1; \
	fi
	@if docker run --rm -v $(CURRENT_DIR)/tests/err:/data $(IMAGE) file-trailing-newline --path .; then \
		exit 1; \
	fi
	@if docker run --rm -v $(CURRENT_DIR)/tests/err:/data $(IMAGE) file-trailing-single-newline --path .; then \
		exit 1; \
	fi
	@if docker run --rm -v $(CURRENT_DIR)/tests/err:/data $(IMAGE) file-trailing-space --path .; then \
		exit 1; \
	fi
	@if docker run --rm -v $(CURRENT_DIR)/tests/err:/data $(IMAGE) file-utf8 --path .; then \
		exit 1; \
	fi
	@if docker run --rm -v $(CURRENT_DIR)/tests/err:/data $(IMAGE) file-utf8-bom --path .; then \
		exit 1; \
	fi

tag:
	docker tag $(IMAGE) $(IMAGE):$(TAG)

pull:
	@grep -E '^\s*FROM' Dockerfile \
		| sed -e 's/^FROM//g' -e 's/[[:space:]]*as[[:space:]]*.*$$//g' \
		| xargs -n1 docker pull;

login:
	yes | docker login --username $(USER) --password $(PASS)

push:
	@$(MAKE) tag TAG=$(TAG)
	docker push $(IMAGE):$(TAG)

enter:
	docker run --rm --name $(subst /,-,$(IMAGE)) -it $(ARG) $(IMAGE):$(TAG) bash