#!/usr/bin/env bash
set -e
IMAGE_VERSION=${1:-17.5-bookworm}
IMAGE_BASE=${2:-bassemkaroui/pgx-ulid-postgres}
CONTAINER=$(docker run -d -e POSTGRES_PASSWORD=pass -p 5433:5432 ${IMAGE_BASE}:${IMAGE_VERSION} postgres -c shared_preload_libraries=pgx_ulid)

# wait for postgres
for i in $(seq 1 30); do
	docker exec $CONTAINER pg_isready -U postgres && break
	sleep 1
done

docker exec -u postgres $CONTAINER psql -c "CREATE EXTENSION IF NOT EXISTS pgx_ulid;" postgres
docker exec -u postgres $CONTAINER psql -c "SELECT gen_ulid();" postgres
docker exec -u postgres $CONTAINER psql -c "SELECT gen_monotonic_ulid();" postgres

docker stop $CONTAINER
docker rm $CONTAINER
