#!/bin/bash
#
# Parse mapping file for downloading operator images 
# from the RH registry using Skopeo.

set -eu

export MAPPING_FILE=${MAPPING_FILE:-"/root/operator/mapping-test.txt"}
export CACHE_DIR=${CACHE_DIR:-"/root/operator/images"}

if [ ! -d "${CACHE_DIR}" ]; then
  mkdir -p ${CACHE_DIR}  
fi

for IMAGE in $(cat ${MAPPING_FILE}); do 
  SRC_IMAGE=$(echo ${IMAGE} | cut -d "=" -f 1)
  DEST_IMAGE=$(echo ${SRC_IMAGE} | rev | cut -d '/' -f 1 | rev)

  if [ ! -f "${CACHE_DIR}/${DEST_IMAGE}/manifest.json" ]; then
    echo "==> Caching '${DEST_IMAGE}' image!"
    
    # pull image to local dir
    skopeo copy -a docker://${SRC_IMAGE} \
      dir:/${CACHE_DIR}/${DEST_IMAGE}

    echo "==> Cache '${DEST_IMAGE}' image done!"
  else
    echo "==> Image '${DEST_IMAGE}' has been cached!"
  fi
done
