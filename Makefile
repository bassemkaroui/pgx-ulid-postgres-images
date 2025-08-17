PG_MAJOR ?= 17
PRE_RELEASE ?= beta2
PG_MINOR ?= 5
DEBIAN_TAG ?= bookworm
IMAGE_NAME ?= bassemkaroui/pgx-ulid-postgres
IMAGE_TAG := $(PG_MAJOR).$(PG_MINOR)-$(DEBIAN_TAG)
IMAGE_PRE_RELEASE_TAG := $(PG_MAJOR)$(PRE_RELEASE)-$(DEBIAN_TAG)

build:
	docker build \
		-f docker/Dockerfile \
		--build-arg PG_MAJOR=$(PG_MAJOR) \
		--build-arg PG_MINOR=$(PG_MINOR) \
		--build-arg DEBIAN_TAG=$(DEBIAN_TAG) \
		-t $(IMAGE_NAME):$(IMAGE_TAG) .

test: build
	./tests/smoke_test.sh $(IMAGE_TAG) $(IMAGE_NAME)

push: test
	docker push $(IMAGE_NAME):$(IMAGE_TAG)

build-pre-release:
	docker build \
		-f docker/Dockerfile.pre-release \
		--build-arg PG_MAJOR=$(PG_MAJOR) \
		--build-arg PRE_RELEASE=$(PRE_RELEASE) \
		--build-arg DEBIAN_TAG=$(DEBIAN_TAG) \
		-t $(IMAGE_NAME):$(IMAGE_PRE_RELEASE_TAG) .

test-pre-release: build-pre-release
	./tests/smoke_test.sh $(IMAGE_PRE_RELEASE_TAG) $(IMAGE_NAME)

push-pre-release: test-pre-release
	docker push $(IMAGE_NAME):$(IMAGE_PRE_RELEASE_TAG)

.PHONY: build test push build-pre-release test-pre-release push-pre-release
