# Version is supplied by docker-compose.yml (COUCHBASE_SERVER_VERSION); default kept in sync for standalone builds.
ARG COUCHBASE_SERVER_VERSION=7.6.9
FROM couchbase/server:${COUCHBASE_SERVER_VERSION} AS stage_base
COPY init-cbserver.sh /opt/couchbase/init/
