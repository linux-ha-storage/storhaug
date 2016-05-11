#!/bin/bash

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

if [[ $NUM_MACH > 0 ]]; then
  conf=$(mktemp)
  vagrant ssh-config > $conf
  scp -rF $conf ${MACHINES[0]}:/tmp/vagrant-cache/* ~/.vagrant.d/cache/centos/7/
fi

if [[ "$1" == "-f" ]]; then
  vagrant destroy
  shift
  set -- ${@:-${MACHINES[@]}}
  vagrant up --no-provision $@
  vagrant provision ${1}
elif [[ "$1" == "-p" ]]; then
  shift
  set -- ${@:-${MACHINES[@]}}
  vagrant rsync $@
  vagrant provision ${1}
else
  set -- ${@:-${MACHINES[@]}}
  vagrant rsync $@
fi

while [[ $# > 0 ]]; do
  vagrant ssh $1 -c "sudo sh -c \"stty cols 80; yum -y reinstall storhaug* | cat\"" | while read -r line; do
    echo -en "[$1] $line\r\n"
  done &
  shift
done

wait
