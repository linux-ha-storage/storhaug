#!/bin/bash

NEW_TAG=$1
NEW_VERSION=""
if [[ "x$NEW_TAG" != "x" ]]; then
  NEW_VERSION="${NEW_TAG:1}"
  HEADREL=1
fi

SPEC="scripts/storhaug.spec"

pushd `git rev-parse --show-toplevel`

OLD_TAG=$(git describe --tags --abbrev=0 HEAD^1)
OLD_VERSION="${OLD_TAG:1}"
VERSION="${NEW_VERSION:-${OLD_VERSION}}"
MIN="${VERSION#*.}"
MAJ="${VERSION%.*}"
RANGE="${OLD_TAG}.. -- src/"
REVLIST=( $(git rev-list ${RANGE}) )
RELEASE=$((${#REVLIST[@]}+1))
HEADREL=${HEADREL:-${RELEASE}}

sed -i "s/\\(define major_version \\).*/\\1${MAJ}/" ${SPEC}
sed -i "s/\\(define minor_version \\).*/\\1${MIN}/" ${SPEC}
sed -i "s/\\(define release \\)[^%]*\\(.*\\)/\\1${HEADREL}\\2/" ${SPEC}

LOG="$(git log --pretty="tformat:* %cd %aN <%aE> - ${VERSION}-${HEADREL}%n%b" --date=local -1 ${REVLIST[$((RELEASE-1))]} | sed -r 's/[0-9]+:[0-9]+:[0-9]+ //'; for ((i=1;i<${#REVLIST[@]};i++)); do git log --format="* %cd %aN <%aE> - ${OLD_VERSION}-$((RELEASE-i))%n%b" --date=local -1 ${REVLIST[i]} | sed -r 's/[0-9]+:[0-9]+:[0-9]+ //'; done)"

if ! grep -q "${VERSION}-${HEADREL}" ${SPEC}; then
  sed "/\%changelog/a ${LOG//$'\n'/\\n}\n" ${SPEC} | vim -c "file ${SPEC}.tmp" -c "/changelog" -

  if [ -f "${SPEC}.tmp" ]; then
    mv ${SPEC}.tmp ${SPEC}
  else
    echo "No changelog saved, aborting release..."
    exit
  fi
fi

./scripts/build-rpms.sh ${VERSION} ${HEADREL} ${SPEC}

popd
