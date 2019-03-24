#!/bin/bash
# Copyright (c) 2019, WSO2 Inc. (http://wso2.org) All Rights Reserved.
#
# WSO2 Inc. licenses this file to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file except
# in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

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
