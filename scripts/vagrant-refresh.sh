#!/bin/bash

cd `git rev-parse --show-toplevel`
cd vagrant-ansible

if [[ "$1" == "-f" ]]; then
  vagrant destroy
  shift
  vagrant up --no-provision $@
  vagrant provision
elif [[ "$1" == "-p" ]]; then
  shift
  vagrant rsync $@
  vagrant provision $@
else
  vagrant rsync $@
fi

while [[ $# > 0 ]]; do
  vagrant ssh $1 -c "sudo sh -c \"cp /shared/source/storhaug /sbin/storhaug; \
                                  cp /shared/source/nfs-ha.conf.sample /etc/sysconfig/storhaug.d/nfs-ha.conf; \
                                  cp /shared/source/smb-ha.conf.sample /etc/sysconfig/storhaug.d/smb-ha.conf; \
                                  sed -i 's/\\\%CONFDIR/\\/etc/' /sbin/storhaug; \
                                  sed -i 's/HA_NODES/HA_CLUSTER_NODES/' /etc/sysconfig/storhaug.conf; \
                                \""
  shift
done
