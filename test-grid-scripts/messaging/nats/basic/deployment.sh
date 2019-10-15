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

readonly basic_request_reply_directory_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
readonly nats_directory_path=$(dirname ${basic_request_reply_directory_path})
readonly messaging_directory_path=$(dirname ${nats_directory_path})
readonly testgrid_scripts_directory_path=$(dirname ${messaging_directory_path})
readonly root_directory_path=$(dirname ${testgrid_scripts_directory_path})

. ${testgrid_scripts_directory_path}/common/usage.sh
. ${testgrid_scripts_directory_path}/setup/setup_deployment_env.sh

setup_deployment() {
    deploy_nats_cluster
    replace_variables_in_bal_files
    build_and_deploy_nats_resources
    wait_for_pod_readiness
    retrieve_and_write_properties_to_data_bucket
    local is_debug_enabled=${infra_config["isDebugEnabled"]}
    if [ "${is_debug_enabled}" = "true" ]; then
        print_kubernetes_debug_info
    fi
}

## Functions

print_kubernetes_debug_info() {
    kubectl get pods
    kubectl get svc proxy-service -o=json
    kubectl get nodes --output wide
}

replace_variables_in_bal_files() {
    replace_variables_in_bal_file ${root_directory_path}/messaging/nats/src/test/resources/basic/src/basic/proxy.bal
    replace_variables_in_bal_file ${root_directory_path}/messaging/nats/src/test/resources/basic/src/basic/subscriber.bal
}

replace_variables_in_bal_file() {
    local bal_path=$1
    sed -i "s:<USERNAME>:${docker_user}:g" ${bal_path}
    sed -i "s:<PASSWORD>:${docker_password}:g" ${bal_path}
    sed -i "s:nats.ballerina.io:${docker_user}:g" ${bal_path}
}

build_and_deploy_nats_resources() {
    docker login --username=${docker_user} --password=${docker_password}
    cd ${root_directory_path}/messaging/nats/src/test/resources/basic
    ${ballerina_home}/bin/ballerina build basic
    cd ../../../../../..
    kubectl apply -f ${root_directory_path}/messaging/nats/src/test/resources/basic/target/kubernetes/basic --namespace=${cluster_namespace}
    # wait_for_pod_readiness
    sleep 240s
    kubectl get nats --namespace=${cluster_namespace}
    kubectl get pods --namespace=${cluster_namespace}
    print_deployment_logs nats-operator
    print_deployment_logs nats-subscriber-service-deployment
    print_deployment_logs proxy-deployment
}

retrieve_and_write_properties_to_data_bucket() {
    local external_ip=$(kubectl get nodes -o=jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
    local node_port=$(kubectl get svc proxy-service -o=jsonpath='{.spec.ports[0].nodePort}')
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

deploy_nats_cluster() {
    docker login --username=${docker_user} --password=${docker_password}
    # This assumes the NATS CRD is available in the cluster.
    kubectl create -f ${root_directory_path}/messaging/nats/src/test/resources/basic/nats-cluster.yaml --namespace=${cluster_namespace}

    wait_for_pod_readiness
    kubectl get nats -o json
    kubectl get pods -o json
}

setup_deployment
