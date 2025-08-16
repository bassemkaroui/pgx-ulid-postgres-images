# pgx-ulid-postgres-images

Minimal Postgres images that add the [`pgx_ulid`](https://github.com/pksunkara/pgx_ulid) extension to the official Postgres Docker images (Debian-based variants) using a two-stage build.

This repository **only** adds the `pgx_ulid` extension on top of the official Postgres images — it does not modify environment variables, default configuration, or runtime behavior other than installing the extension. All runtime environment variables, volumes, and configuration are exactly the same as the official Postgres images; for general usage and advanced runtime options please refer to the official Postgres image documentation on Docker Hub.

- Official Postgres Docker Hub: [postgres](https://hub.docker.com/_/postgres)
- Dockerfile in this repository: [bassemkaroui/pgx-ulid-postgres-images/docker/Dockerfile](https://github.com/bassemkaroui/pgx-ulid-postgres-images/blob/main/docker/Dockerfile)

## What this repo provides

- A small, reproducible Docker image that contains the `pgx_ulid` extension compiled and installed for a chosen Postgres major/minor version.
- A multi-stage build: the builder stage compiles the Rust-based extension; the runtime stage copies only the resulting extension files into the official Postgres runtime image to keep the final image size minimal.
- Convenience scripts and a `Makefile` for local builds, smoke tests, and pushing images to registries.

**Important:** These images are built from the official Debian-based Postgres images (e.g. `*-bookworm`). If you need a different base OS variant, build arguments are available in the Dockerfile and `Makefile`.

## Supported / configurable values

The provided Dockerfile accepts build arguments so you can target different Postgres majors/minors and Debian tags. The `Makefile` in the repo exposes variables like `PG_MAJOR`, `PG_MINOR`, and `DEBIAN_TAG` for convenience.

Example defaults used in the repo:

```text
PG_MAJOR=17
PG_MINOR=5
DEBIAN_TAG=bookworm
```

You can override those when building locally (see `Usage` below).

## Usage

### Run a published image

```bash
docker run -d --name pg -e POSTGRES_PASSWORD=pass -p 5432:5432 bassemkaroui/pgx-ulid-postgres:17.5-bookworm
# then inside psql:
psql -h localhost -U postgres -c "CREATE EXTENSION IF NOT EXISTS pgx_ulid;"
psql -h localhost -U postgres -c "SELECT gen_ulid();"
psql -h localhost -U postgres -c "SELECT gen_monotonic_ulid();"
```

### Build locally

Build the image locally with the provided `Makefile` (example):

```bash
# builds: bassemkaroui/pgx-ulid-postgres:17.5-bookworm
make build
```

Or explicitly:

```bash
PG_MAJOR=17 PG_MINOR=5 DEBIAN_TAG=bookworm make build
```

### Test the image (smoke test)

A smoke test script is included under `tests/smoke_test.sh`. The `Makefile` includes a `test` target that runs the smoke test after building the image. The smoke test will start a container, wait for readiness, create the extension and run a couple of basic function calls. If the test succeeds the image is valid for pushing.

```bash
make test
# or build+test+push
make push
```

> The smoke test will always clean up the test container even if the test fails.

## License

This project is released under the **MIT License**. See [LICENSE](https://github.com/bassemkaroui/pgx-ulid-postgres-images/blob/main/LICENSE) for details.
