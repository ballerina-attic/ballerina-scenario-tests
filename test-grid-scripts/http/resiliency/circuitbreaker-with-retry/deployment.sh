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

readonly deployment_cb_with_retry_parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
readonly deployment_cb_with_retry_grand_parent_path=$(dirname ${deployment_cb_with_retry_parent_path})
readonly deployment_cb_with_retry_great_grand_parent_path=$(dirname ${deployment_cb_with_retry_grand_parent_path})

. ${deployment_cb_with_retry_grand_parent_path}/common/usage.sh
. ${deployment_cb_with_retry_grand_parent_path}/setup/setup_deployment_env.sh

function setup_deployment() {
    clone_repo_and_set_bal_path
    replace_variables_in_bal_files
    build_and_deploy_artemis_resources
    wait_for_pod_readiness
    retrieve_and_write_properties_to_data_bucket
    local is_debug_enabled=${infra_config["isDebugEnabled"]}
    if [ "${is_debug_enabled}" = "true" ]; then
        print_kubernetes_debug_info
    fi
}

## Functions

function clone_repo_and_set_bal_path() {
    git clone https://github.com/ballerina-platform/ballerina-scenario-tests.git
    backend_bal_path=http/resiliency/src/test/resources/source_files/circuitbreaker-with-retry-test/http1_service.bal
    cb_bal_path=http/resiliency/src/test/resources/source_files/circuitbreaker-with-retry-test/http1_circuit_breaker.bal
    retry_bal_path=http/resiliency/src/test/resources/source_files/circuitbreaker-with-retry-test/http1_retry.bal
}

function print_kubernetes_debug_info() {
    kubectl get pods
    kubectl get nodes --output wide
}

function replace_variables_in_bal_files() {
    replace_variables_in_bal_file ${backend_bal_path}
    replace_variables_in_bal_file ${cb_bal_path}
    replace_variables_in_bal_file ${retry_bal_path}
}

function replace_variables_in_bal_file() {
    local bal_path=$1
    sed -i "s:<USERNAME>:${docker_user}:g" ${bal_path}
    sed -i "s:<PASSWORD>:${docker_password}:g" ${bal_path}
    sed -i "s:resiliency.ballerina.io:${docker_user}:g" ${bal_path}
}

## ***************************** TODO: Fix these **************************
function build_and_deploy_artemis_resources() {
    cd connectors/artemis/src/test/resources/dual-channel-scenario
    ${ballerina_home}/bin/ballerina init
    ${ballerina_home}/bin/ballerina build
    cd ../../../../../..
    kubectl apply -f ${work_dir}/connectors/artemis/src/test/resources/dual-channel-scenario/target/kubernetes/consumer --namespace=${cluster_namespace}
    kubectl apply -f ${work_dir}/connectors/artemis/src/test/resources/dual-channel-scenario/target/kubernetes/remote --namespace=${cluster_namespace}
    kubectl apply -f ${work_dir}/connectors/artemis/src/test/resources/dual-channel-scenario/target/kubernetes/sender --namespace=${cluster_namespace}
}

function retrieve_and_write_properties_to_data_bucket() {
    local external_ip=$(kubectl get nodes -o=jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
    local node_port=$(kubectl get svc artemis-sender -o=jsonpath='{.spec.ports[0].nodePort}')
    declare -A deployment_props
    deployment_props["ExternalIP"]=${external_ip}
    deployment_props["NodePort"]=${node_port}
    write_to_properties_file ${output_dir}/deployment.properties deployment_props
    local is_debug_enabled=${infra_config["isDebugEnabled"]}
    if [ "${is_debug_enabled}" = "true" ]; then
        echo "ExternalIP: ${external_ip}"
        echo "NodePort: ${node_port}"
    fi
}

setup_deployment
