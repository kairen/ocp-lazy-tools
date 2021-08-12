#!/bin/bash
#
# Parse mapping file for importing images to the local registry using Skopeo.

set -eu

export MAPPING_FILE=${MAPPING_FILE:-"/root/mapping.txt"}
export CACHE_DIR=${CACHE_DIR:-"/root/operator-images"}
export REGISTRY_HOST=${REGISTRY_HOST:-"registry.example.tw:5000"}

if [ -d "${CACHE_DIR}" ]; then
  for IMAGE in $(cat ${MAPPING_FILE}); do 
    SRC_IMAGE=$(echo ${IMAGE} | cut -d "=" -f 1)
    DEST_IMAGE=$(echo ${SRC_IMAGE} | rev | cut -d '/' -f 1 | rev)

    # IMPORT_IMAGE_DIR=$(echo ${DEST_IMAGE} | sed 's/@/-/g' | sed 's/:/-/g')
    if [ -f "${CACHE_DIR}/${DEST_IMAGE}/manifest.json" ]; then
      echo "==> Importing '${DEST_IMAGE}' image!"
      NAME=$(echo ${DEST_IMAGE} | cut -d '@' -f 1)
      NAMESPACE=$(echo ${SRC_IMAGE} | rev | cut -d '/' -f 2 | rev)

      # copy local image to registry
      skopeo copy -a dir:/${CACHE_DIR}/${DEST_IMAGE} \
        docker://${REGISTRY_HOST}/${NAMESPACE}/${NAME}
      
      echo "==> Import '${DEST_IMAGE}' image done!"
    fi
 done
else
  echo "Cannot access '${CACHE_DIR}': No such file or directory!"
  exit 1
fi


