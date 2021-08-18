#!/bin/bash
#
# Install ocp tools which including oc, opm, kubectl, ..., and so on.

set -eu

export INSTALL_CLI=${INSTALL_CLI:="true"}
export INSTALL_OPM=${INSTALL_CLI:="false"}

export CLI_MIRROR_URL=${OCP_MIRROR_URL:-"https://mirror.openshift.com/pub/openshift-v4/clients/ocp"}
export BIN_PATH=${BIN_PATH:="/usr/local/bin/"}

read -sr VERSION_INPUT
export VERSION=${$VERSION_INPUT:-"stable-4.8"}

if [[ $INSTALL_CLI = true ]]; then
  echo "==== Starting to install openshift client"
  wget -c ${CLI_MIRROR_URL}/${VERSION_INPUT}/openshift-client-linux.tar.gz -O - | tar -xz
  mv {oc,kubectl} ${BIN_PATH}
fi

if [[ $INSTALL_OPM = true ]]; then
  echo "==== Starting to install opm"
  wget -c ${CLI_MIRROR_URL}/${VERSION_INPUT}/opm-linux.tar.gz -O - | tar -xz
  wget -c https://github.com/fullstorydev/grpcurl/releases/download/v1.8.2/grpcurl_1.8.2_linux_x86_64.tar.gz -O - | tar -xz
  mv {oc,kubectl} ${BIN_PATH}
fi