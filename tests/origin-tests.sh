#!/bin/bash

set -eu

podman run -v ${LOCAL_KUBECONFIG}:/root/.kube/config:z -i quay.io/openshift/origin-tests:4.8 /bin/bash -c 'export KUBECONFIG=/root/.kube/config && \
openshift-tests run-test "[sig-scalability][Feature:Performance] Load cluster \
should populate the cluster [Slow][Serial] [Suite:openshift]"'