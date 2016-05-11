#!/bin/bash

VERSION="${1}"
HEADREL="${2:-1}"
SPEC="${3:-scripts/storhaug.spec}"

pushd `git rev-parse --show-toplevel`

tar -czvf storhaug-${VERSION}.tar.gz --transform='s/^src/storhaug/' src/*

rpmbuild -bs -D 'rhel 6' -D "_topdir `pwd`" -D "_sourcedir ." -D "dist .el6.centos" ${SPEC}
rpmbuild -bs -D 'rhel 7' -D "_topdir `pwd`" -D "_sourcedir ." -D "dist .el7.centos" ${SPEC}
rm -f storhaug-${VERSION}.tar.gz

rm -rf repo/*/*
mock -r epel-6-x86_64 --resultdir repo/el6/ SRPMS/storhaug-${VERSION}-${HEADREL}.el6.centos.src.rpm
mock -r epel-7-x86_64 --resultdir repo/el7/ SRPMS/storhaug-${VERSION}-${HEADREL}.el7.centos.src.rpm
createrepo repo/el6/
createrepo repo/el7/

rm -f repo/*/*.log
rm -rf BUILD/ BUILDROOT/ RPMS/ SPECS/ SRPMS/

popd
