#!/bin/bash

CTDB_STATUS=""
DIR=$( dirname "${BASH_SOURCE[0]}" )
TIMEOUT="${DIR}/timeout3.sh"

if [ -e /etc/ctdb/nodes ]; then
  CTDB_STATUS="echo; ${TIMEOUT} ctdb status && echo && ${TIMEOUT} ctdb getcapabilities;"
fi

watch -n1 "echo 'hostname: '`hostname`; echo; ${TIMEOUT} pcs status; ${CTDB_STATUS}"
