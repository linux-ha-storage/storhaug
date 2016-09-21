#!/bin/bash

DESTROY=false
PROVISION=false

cd `git rev-parse --show-toplevel`
cd vagrant-ansible

VSTATUS=$(vagrant status)
VRC=$?

if [ $VRC -ne 0 ]; then
  echo -n $VSTATUS
  exit $VRC
fi

MACHINES=( $(echo "$VSTATUS" | grep "running" | awk '{print $1}') )
NUM_MACH=${#MACHINES[@]}

if [[ "$1" == "-f" ]]; then
  DESTROY=true
  PROVISION=true
  shift
elif [[ "$1" == "-p" ]]; then
  PROVISION=true
  shift
fi

set -- ${@:-${MACHINES[@]}}

if [[ $DESTROY ]]; then
  vagrant destroy
  vagrant up --no-provision $@
fi

if [[ $PROVISION ]]; then
  vagrant provision ${1}
fi

if [[ ! $DESTROY ]]; then
  vagrant rsync $@
  while [[ $# > 0 ]]; do
    vagrant ssh $1 -c "sudo sh -c \"stty cols 80; yum -y makecache all; yum -y reinstall storhaug* | cat\"" | while read -r line; do
      echo -en "[$1] $line\r\n"
    done &
    shift
  done
fi

wait
