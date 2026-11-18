#!/bin/bash
# used to start sync - can't get around this as docker compose only allows you to start one command - so we have to start sync gateway like the standard sync gateway Dockerfile would 
# https://github.com/couchbase/docker/blob/master/enterprise/sync-gateway/3.0.4/Dockerfile#L27

# docker-compose.yml starts this container only after Couchbase Server reports healthy
# (bucket, RBAC user and index created), so no startup delay is needed here.
/entrypoint.sh /etc/sync_gateway/config.json & 

# docker compose will stop the container from running unless we do this
# known issue and workaround
tail -f /dev/null