CUSTOM_DOMAIN=$(shell cat serverless.yml | grep "serverless-domain-manager" | wc -l)

ifeq ("$(wildcard ../node_modules)","../node_modules")
	ROOT=..
else ifeq ("$(wildcard ../../node_modules)","../../node_modules")
	ROOT=../..
else
	ROOT=../../..
endif

clean:
	rm -rf bin

build-v1:
ifneq ("$(wildcard v1/main.go)","")
	go build -ldflags="-s -w" -o bin/v1 v1/*.go
endif
ifneq ("$(wildcard v1/cmd/lambda/main.go)","")
	go build -ldflags="-s -w" -o bin/v1 v1/cmd/lambda/main.go
endif
ifneq ("$(wildcard v2/main.go)","")
	go build -ldflags="-s -w" -o bin/v2 v2/*.go
endif

deploy:
ifeq ($(CUSTOM_DOMAIN), 1)
	$(ROOT)/node_modules/.bin/serverless create_domain --stage production
endif
	$(ROOT)/node_modules/.bin/serverless deploy --stage production
