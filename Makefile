PG_MAJOR ?= 17
PG_MINOR ?= 5
DEBIAN_TAG ?= bookworm
IMAGE_NAME ?= bassemkaroui/pgx-ulid-postgres
IMAGE_TAG := $(PG_MAJOR).$(PG_MINOR)-$(DEBIAN_TAG)

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

.PHONY: build test push
