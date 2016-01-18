#!/bin/bash

SPEC="scripts/storage-ha.spec"

pushd `git rev-parse --show-toplevel`

TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
VERSION="${TAG:1}"
MIN="${VERSION#*.}"
MAJ="${VERSION%.*}"
RANGE="${TAG}^1.. -- src/"
RELEASE=$(git rev-list ${RANGE} | wc -l)

sed -i "s/\\(define major_version \\).*/\\1${MAJ}/" ${SPEC}
sed -i "s/\\(define minor_version \\).*/\\1${MIN}/" ${SPEC}
sed -i "s/\\(define release \\)[^%]*\\(.*\\)/\\1${RELEASE}\\2/" ${SPEC}

LOG=$(git log --format="* %cd %aN <%aE> - ${VERSION}-${RELEASE}%n%b" --date=local -1 ${RANGE} | sed -r 's/[0-9]+:[0-9]+:[0-9]+ //')

sed -i "/\%changelog/a ${LOG//$'\n'/\\n}" ${SPEC}

vim ${SPEC}

tar -czvf storage-ha-${VERSION}.tar.gz --transform='s/^src/storage-ha/' src/*

rpmbuild -bs -D 'rhel 6' -D "_topdir `pwd`" -D "_sourcedir ." -D "dist .el6.centos" ${SPEC}
rpmbuild -bs -D 'rhel 7' -D "_topdir `pwd`" -D "_sourcedir ." -D "dist .el7.centos" ${SPEC}
rm -f storage-ha-${VERSION}.tar.gz

rm -rf repo/*/*
mock -r epel-6-x86_64 --resultdir repo/el6/ SRPMS/storage-ha-${VERSION}-${RELEASE}.el6.centos.src.rpm
mock -r epel-7-x86_64 --resultdir repo/el7/ SRPMS/storage-ha-${VERSION}-${RELEASE}.el7.centos.src.rpm
createrepo repo/el6/
createrepo repo/el7/

rm -f repo/*/*.log
rm -rf BUILD/ BUILDROOT/ RPMS/ SPECS/ SRPMS/

popd
