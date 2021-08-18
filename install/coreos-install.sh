#!/bin/bash
#
# A script for easy executing coreos-installer on UPI installation.

set -eu 

export DEVICE_NAME=${DEVICE_NAME:-"/dev/sda"}
export IGNITION_FILE=${IGNITION_FILE:-"bootstrap.ign"} # bootstrap.ign  master.ign  worker.ign 
export IGNITION_URL=${IGNITION_URL:-"http://10.77.110.39:8080/ignition"}

sudo coreos-installer install ${DEVICE_NAME} \
  --insecure-ignition \
  --ignition-url=${IGNITION_URL}/${IGNITION_FILE} \
  --firstboot-args 'rd.neednet=1' \
  --copy-network