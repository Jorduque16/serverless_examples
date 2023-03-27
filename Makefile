
A1=$(subst build.,,$(subst deploy.,,$(subst logs.,,$@)))
A0=$(subst .,/,$(A1))

OMIT=^Makefile\

DIR_LIST=$(shell find $(shell ls) -type f -name Makefile ! -path 'node_modules/*' ! -path 'examples/*' | grep -v '$(OMIT)' | sed "s;/Makefile;;g" | sed "s;/;.;g")

build: $(foreach m,$(DIR_LIST),build.$(m))

$(foreach m,$(DIR_LIST),build.$(m)):
	@echo
	@echo "** build $(A0)"
	@$(MAKE) --no-print-directory -C $(A0) build

deploy: $(foreach m,$(DIR_LIST),deploy.$(m))

$(foreach m,$(DIR_LIST),deploy.$(m)):
	@echo "** deploy $(A0) start"
	@$(MAKE) --no-print-directory -C $(A0) deploy > _pipeline_tmp/logs/deploy-$(A1).log 2>&1
	@echo "** deploy $(A0) ok"

$(foreach m,$(DIR_LIST),logs.$(m)):
	@echo -e "\n\n\n\n\n\n$(A0)\n\n"
	@cat _pipeline_tmp/logs/deploy-$(A1).log || true

logs: $(foreach m,$(DIR_LIST),logs.$(m))

PACKAGES := $(shell go list ./... | grep -vE "vendor|examples" )

fmt:
	go fmt $(PACKAGES)