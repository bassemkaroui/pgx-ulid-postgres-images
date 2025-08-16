PG_MAJOR ?= 17
PG_MINOR ?= 5
DEBIAN_TAG ?= bookworm
IMAGE_NAME ?= bassemkaroui/pgx-ulid-postgres

build:
	docker build -f docker/Dockerfile --build-arg PG_MAJOR=$(PG_MAJOR) --build-arg PG_MINOR=$(PG_MINOR) --build-arg DEBIAN_TAG=$(DEBIAN_TAG) -t $(IMAGE_NAME):$(PG_MAJOR).$(PG_MINOR)-$(DEBIAN_TAG) .

push:
	docker push $(IMAGE_NAME):$(PG_MAJOR).$(PG_MINOR)-$(DEBIAN_TAG)

.PHONY: build push
