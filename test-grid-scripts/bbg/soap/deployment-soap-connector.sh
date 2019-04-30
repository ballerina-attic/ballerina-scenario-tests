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

readonly deployment_soap_parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
readonly deployment_soap_grand_parent_path=$(dirname ${deployment_soap_parent_path})
readonly deployment_soap_great_grand_parent_path=$(dirname ${deployment_soap_grand_parent_path})

. ${deployment_soap_great_grand_parent_path}/common/usage.sh
. ${deployment_soap_great_grand_parent_path}/setup/setup_deployment_env.sh

function setup_deployment() {
    clone_bbg_and_set_bal_path
    deploy_soap_resources
    replace_variables_in_bal_file
    build_and_deploy_soap_client
    wait_for_pod_readiness
    retrieve_and_write_properties_to_data_bucket
    local is_debug_enabled=${infra_config["isDebugEnabled"]}
    if [ "${is_debug_enabled}" = "true" ]; then
        print_kubernetes_debug_info
    fi
}

## Functions

function clone_bbg_and_set_bal_path() {
    local bbg_repo_name="soap-messaging"
    clone_soap_repo ${bbg_repo_name}
    bal_path=${bbg_repo_name}/soap/soapMessaging.bal
}

function print_kubernetes_debug_info() {
    cat ${bal_path}
    kubectl get pods
    kubectl get svc soap-client -o=json
    kubectl get nodes --output wide
}

function replace_variables_in_bal_file() {
    sed -i "s:<USERNAME>:${docker_user}:g" ${bal_path}
    sed -i "s:<PASSWORD>:${docker_password}:g" ${bal_path}
    sed -i "s:ballerina.guides.io:${docker_user}:g" ${bal_path}
}

function build_and_deploy_soap_client() {
    cd soap-messaging
    ${ballerina_home}/bin/ballerina init
    ${ballerina_home}/bin/ballerina build soap-client --skiptests
    cd ../
    kubectl apply -f ${work_dir}/soap-messaging/target/kubernetes/soap-client
}

function deploy_soap_resources() {
    docker login --username=${docker_user} --password=${docker_password}

    kubectl create -f soap-messaging/soap-client/resources/soap-deployment.yaml
    kubectl create -f soap-messaging/soap-client/resources/soap-service.yaml
    wait_for_pod_readiness
    kubectl get svc
}

function retrieve_and_write_properties_to_data_bucket() {
    local external_ip=$(kubectl get nodes -o=jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
    local node_port=$(kubectl get svc soap-client -o=jsonpath='{.spec.ports[0].nodePort}')
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
