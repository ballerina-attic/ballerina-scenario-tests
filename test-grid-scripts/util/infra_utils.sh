#!/usr/bin/env bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
. ${parent_path}/common_utils.sh

# Deletes all k8s resources in the used namespace. The relevant namespace is taken from
# infrastructure-cleanup.properties.
function cleanup_k8s_resources() {
    local -n __infra_cleanup_config=$1
    local namespace=${__infra_cleanup_config[NamespacesToCleanup]}
    if [ "${namespace}" != "" ]; then
        kubectl -n ${namespace} delete deployment,po,svc --all
        kubectl delete namespaces ${namespace}
    else
        echo "Namespace string is empty"
    fi
}

function read_infra_cleanup_props() {
    # Read configuration into an associative array
    local input_dir=$1
    local -n __infra_cleanup_config=$2
    read_property_file "${input_dir}/infrastructure-cleanup.properties" __infra_cleanup_config
}
