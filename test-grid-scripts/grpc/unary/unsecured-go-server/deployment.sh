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

readonly unsecured_go_server_dir_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
readonly grpc_unary_dir_path=$(dirname ${unsecured_go_server_dir_path})
readonly grpc_dir_path=$(dirname ${grpc_unary_dir_path})
readonly test_grid_scripts_dir_path=$(dirname ${grpc_dir_path})

. ${test_grid_scripts_dir_path}/common/usage.sh
. ${test_grid_scripts_dir_path}/setup/setup_deployment_env.sh

function setup_deployment() {
    clone_repo_and_set_bal_path
    deploy_unary_go_server
    replace_variables_in_bal_files
    build_and_deploy_grpc_client_resources
    wait_for_pod_readiness
    retrieve_and_write_properties_to_data_bucket
    local is_debug_enabled=${infra_config["isDebugEnabled"]}
    if [ "${is_debug_enabled}" = "true" ]; then
        print_kubernetes_debug_info
    fi
}

readonly DIRECTORY_NAME="grpc/unary/src/test/resources/grpc-scenarios"

## Functions

function clone_repo_and_set_bal_path() {
    product_Info_client_bal_path=grpc/unary/src/test/resources/grpc-scenarios/src/unsecured_client/product_Info_client.bal
}

function deploy_unary_go_server() {
    docker login --username=${docker_user} --password=${docker_password}

    kubectl create -f grpc/unary/src/test/resources/grpc-scenarios/src/unsecured_client/resources/go-grpc-service.yaml
    wait_for_pod_readiness
    kubectl get svc
}

function print_kubernetes_debug_info() {
    kubectl get pods
    kubectl get svc ballerina-grpc-client-proxy -o=json
    kubectl get nodes --output wide
}

function replace_variables_in_bal_files() {
    replace_variables_in_bal_file ${product_Info_client_bal_path}
}

function replace_variables_in_bal_file() {
    local bal_path=$1
    sed -i "s:<USERNAME>:${docker_user}:g" ${bal_path}
    sed -i "s:<PASSWORD>:${docker_password}:g" ${bal_path}
}

function build_and_deploy_grpc_client_resources() {
    cd ${DIRECTORY_NAME}
    ${ballerina_home}/bin/ballerina build unsecured_client
    cd ../../../../../../..
    echo $PWD
    echo ${work_dir}/${DIRECTORY_NAME}/target/kubernetes
    set -x
    kubectl apply -f ${work_dir}/${DIRECTORY_NAME}/target/kubernetes/unsecured_client --namespace=${cluster_namespace}
    set +x
}

function retrieve_and_write_properties_to_data_bucket() {
    local external_ip=$(kubectl get nodes --namespace=${cluster_namespace} -o=jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
    local node_port=$(kubectl get svc ballerina-grpc-client-proxy --namespace=${cluster_namespace} -o=jsonpath='{.spec.ports[0].nodePort}')
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
