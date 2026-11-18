# Version is supplied by docker-compose.yml (SYNC_GATEWAY_VERSION); default kept in sync for standalone builds.
# couchbase/sync-gateway publishes no "latest" tag, so a tag must always be given.
ARG SYNC_GATEWAY_VERSION=3.2.6-enterprise
FROM couchbase/sync-gateway:${SYNC_GATEWAY_VERSION} AS stage_base
COPY sync-gateway.json /etc/sync_gateway/config.json
COPY init-syncgateway.sh /opt/couchbase-sync-gateway/init/init-syncgateway.sh
