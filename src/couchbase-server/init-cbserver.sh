#!/bin/bash
# used to start couchbase server - can't get around this as docker compose only allows you to start one command - so we have to start couchbase like the standard couchbase Dockerfile would 
# https://github.com/couchbase/docker/blob/master/enterprise/couchbase-server/7.1.1/Dockerfile#L88

/entrypoint.sh couchbase-server & 

# track if setup is complete so we don't try to setup again.
# docker-compose.yml's healthcheck reports healthy only once this file exists,
# so Sync Gateway starts after the bucket, RBAC user and index are ready.
FILE=/opt/couchbase/init/setupComplete.txt

# wait_for <description> <command...>: retry a readiness check instead of sleeping a fixed time
wait_for() {
  local what=$1; shift
  for _ in $(seq 1 120); do
    if "$@" > /dev/null 2>&1; then
      echo "ready: $what"
      return 0
    fi
    sleep 2
  done
  echo "timed out waiting for $what" >&2
  exit 1
}

if ! [ -f "$FILE" ]; then
  # used to automatically create the cluster based on environment variables
  # https://docs.couchbase.com/server/current/cli/cbcli/couchbase-cli-cluster-init.html

  echo $COUCHBASE_ADMINISTRATOR_USERNAME ":"  $COUCHBASE_ADMINISTRATOR_PASSWORD  

  wait_for "cluster manager (8091)" /opt/couchbase/bin/curl -sf http://127.0.0.1:8091/ui/index.html
  /opt/couchbase/bin/couchbase-cli cluster-init -c 127.0.0.1 \
  --cluster-username $COUCHBASE_ADMINISTRATOR_USERNAME \
  --cluster-password $COUCHBASE_ADMINISTRATOR_PASSWORD \
  --services data,index,query \
  --cluster-ramsize $COUCHBASE_RAM_SIZE \
  --cluster-index-ramsize $COUCHBASE_INDEX_RAM_SIZE \
  --index-storage-setting default

  # used to auto create the bucket based on environment variables
  # https://docs.couchbase.com/server/current/cli/cbcli/couchbase-cli-bucket-create.html

  /opt/couchbase/bin/couchbase-cli bucket-create -c localhost:8091 \
  --username $COUCHBASE_ADMINISTRATOR_USERNAME \
  --password $COUCHBASE_ADMINISTRATOR_PASSWORD \
  --bucket $COUCHBASE_BUCKET \
  --bucket-ramsize $COUCHBASE_BUCKET_RAMSIZE \
  --bucket-type couchbase \
  --wait

  # used to auto create the sync gateway user based on environment variables  
  # https://docs.couchbase.com/server/current/cli/cbcli/couchbase-cli-user-manage.html#examples

  /opt/couchbase/bin/couchbase-cli user-manage \
  --cluster http://127.0.0.1 \
  --username $COUCHBASE_ADMINISTRATOR_USERNAME \
  --password $COUCHBASE_ADMINISTRATOR_PASSWORD \
  --set \
  --rbac-username $COUCHBASE_RBAC_USERNAME \
  --rbac-password $COUCHBASE_RBAC_PASSWORD \
  --roles mobile_sync_gateway[*] \
  --auth-domain local

  # the query and index services can lag behind the bucket, so retry until the index is created
  wait_for "index idx_type" /opt/couchbase/bin/curl -sf http://localhost:8093/query/service \
  -u $COUCHBASE_ADMINISTRATOR_USERNAME:$COUCHBASE_ADMINISTRATOR_PASSWORD \
  -d "statement=CREATE INDEX idx_type IF NOT EXISTS ON \`$COUCHBASE_BUCKET\`(type)"

  # create file so we know that the cluster is setup and don't run the setup again 
  touch $FILE
fi 
  # docker compose will stop the container from running unless we do this
  # known issue and workaround
  tail -f /dev/null

