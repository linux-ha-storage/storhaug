#!/bin/bash

CTDB_STATUS=""

if [ -e /etc/ctdb/nodes ]; then
  CTDB_STATUS="echo; ctdb status;"
fi

watch -n1 "pcs status; ${CTDB_STATUS}"
