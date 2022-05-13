.PHONY: default
UPSTREAM_VERSION_FILE = UPSTREAM_VERSION.txt
UPSTREAM_VERSION = `cat $(UPSTREAM_VERSION_FILE)`
DEFAULT_BUILD_ARGS = --build-arg http_proxy=$(http_proxy) --build-arg https_proxy=$(https_proxy) --build-arg no_proxy=$(no_proxy)
SOURCE_IMAGE=jforge/jenkins-jnlp-slave

default: build-alpine

build-all: build-alpine build-debian build-jdk11

build-alpine:
	docker build --rm --force-rm -t $(SOURCE_IMAGE):alpine $(DEFAULT_BUILD_ARGS) --build-arg=FROM_TAG=$(UPSTREAM_VERSION)-alpine .
	docker tag $(SOURCE_IMAGE):alpine $(SOURCE_IMAGE):latest

build-debian:
	docker build --rm --force-rm -t $(SOURCE_IMAGE):debian $(DEFAULT_BUILD_ARGS) --build-arg=FROM_TAG=$(UPSTREAM_VERSION) .

build-jdk11:
	docker build --rm --force-rm -t $(SOURCE_IMAGE):jdk11 $(DEFAULT_BUILD_ARGS) --build-arg=FROM_TAG=$(UPSTREAM_VERSION)-jdk11 .

publish: build-all
	./publish.sh

release:
	$(eval NEW_INCREMENT := $(shell expr `git describe --tags --abbrev=0 | cut -d'-' -f3` + 1))
	git tag v$(UPSTREAM_VERSION)-$(NEW_INCREMENT)
	git push origin v$(UPSTREAM_VERSION)-$(NEW_INCREMENT)
