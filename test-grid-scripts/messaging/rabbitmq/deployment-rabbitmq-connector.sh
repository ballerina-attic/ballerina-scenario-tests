#!/bin/bash
# Copyright (c) 2020, WSO2 Inc. (http://wso2.org) All Rights Reserved.
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

readonly rabbitmq_directory_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
readonly messaging_directory_path=$(dirname ${rabbitmq_directory_path})
readonly testgrid_scripts_directory_path=$(dirname ${messaging_directory_path})
readonly root_directory_path=$(dirname ${testgrid_scripts_directory_path})

. ${testgrid_scripts_directory_path}/common/usage.sh
. ${testgrid_scripts_directory_path}/setup/setup_deployment_env.sh

function setup_deployment() {
    clone_repo_and_set_bal_path
    deploy_rabbitmq_broker
    replace_variables_in_bal_files
    build_and_deploy_rabbitmq_resources
    wait_for_pod_readiness
    retrieve_and_write_properties_to_data_bucket
    local is_debug_enabled=${infra_config["isDebugEnabled"]}
    if [ "${is_debug_enabled}" = "true" ]; then
        print_kubernetes_debug_info
    fi
}

## Functions

function clone_repo_and_set_bal_path() {
    publisher_bal_path=${root_directory_path}/messaging/rabbitmq/src/test/resources/publisher-subscriber/src/publisher-subscriber/publisher.bal
    cc_publisher_bal_path=${root_directory_path}/messaging/rabbitmq/src/test/resources/competing-consumer/src/competing-consumer/producer.bal
    dc_publisher_bal_path=${root_directory_path}/messaging/rabbitmq/src/test/resources/dual-channel/src/dual-channel/dual-channel.bal
    fanout_bal_path=${root_directory_path}/messaging/rabbitmq/src/test/resources/fanout/src/fanout/fanout.bal
}

function deploy_rabbitmq_broker() {
    docker login --username=${docker_user} --password=${docker_password}

    kubectl create -f ${root_directory_path}/messaging/rabbitmq/src/test/resources/rabbitmq-deployment.yaml --namespace=${cluster_namespace}
    kubectl create -f ${root_directory_path}/messaging/rabbitmq/src/test/resources/rabbitmq-service.yaml --namespace=${cluster_namespace}
    wait_for_pod_readiness
    kubectl get svc --namespace=${cluster_namespace}
}

function print_kubernetes_debug_info() {
    kubectl get pods --namespace=${cluster_namespace}
    kubectl get svc rabbitmq-publisher -o=json --namespace=${cluster_namespace}
    kubectl get svc rabbitmq-competing-consumer -o=json --namespace=${cluster_namespace}
    kubectl get nodes --output wide --namespace=${cluster_namespace}
}

function replace_variables_in_bal_files() {
    replace_variables_in_bal_file ${publisher_bal_path}
    replace_variables_in_bal_file ${cc_publisher_bal_path}
    replace_variables_in_bal_file ${dc_publisher_bal_path}
    replace_variables_in_bal_file ${fanout_bal_path}
}

function replace_variables_in_bal_file() {
    local bal_path=$1
    sed -i "s:<USERNAME>:${docker_user}:g" ${bal_path}
    sed -i "s:<PASSWORD>:${docker_password}:g" ${bal_path}
    sed -i "s:rabbitmq.ballerina.io:${docker_user}:g" ${bal_path}
}

function build_and_deploy_rabbitmq_resources() {
    cd ${root_directory_path}/messaging/rabbitmq/src/test/resources/fanout
    ${ballerina_home}/bin/ballerina build fanout
    cd ../../../../../..
    kubectl apply -f ${root_directory_path}/messaging/rabbitmq/src/test/resources/fanout/target/kubernetes/fanout --namespace=${cluster_namespace}
    cd ${root_directory_path}/messaging/rabbitmq/src/test/resources/publisher-subscriber
    ${ballerina_home}/bin/ballerina build publisher-subscriber
    cd ../../../../../..
    kubectl apply -f ${root_directory_path}/messaging/rabbitmq/src/test/resources/publisher-subscriber/target/kubernetes/publisher-subscriber --namespace=${cluster_namespace}
    cd ${root_directory_path}/messaging/rabbitmq/src/test/resources/competing-consumer
    ${ballerina_home}/bin/ballerina build competing-consumer
    cd ../../../../../..
    kubectl apply -f ${root_directory_path}/messaging/rabbitmq/src/test/resources/competing-consumer/target/kubernetes/competing-consumer --namespace=${cluster_namespace}
    cd ${root_directory_path}/messaging/rabbitmq/src/test/resources/dual-channel
    ${ballerina_home}/bin/ballerina build dual-channel
    cd ../../../../../..
    kubectl apply -f ${root_directory_path}/messaging/rabbitmq/src/test/resources/dual-channel/target/kubernetes/dual-channel --namespace=${cluster_namespace}
}

function retrieve_and_write_properties_to_data_bucket() {
    local external_ip=$(kubectl get nodes -o=jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}' --namespace=${cluster_namespace})
    local publisher_node_port=$(kubectl get svc rabbitmq-publisher -o=jsonpath='{.spec.ports[0].nodePort}' --namespace=${cluster_namespace})
    local competing_consumer_node_port=$(kubectl get svc rabbitmq-competing-consumer -o=jsonpath='{.spec.ports[0].nodePort}' --namespace=${cluster_namespace})
    local dual_channel_node_port=$(kubectl get svc rabbitmq-dual-channel -o=jsonpath='{.spec.ports[0].nodePort}' --namespace=${cluster_namespace})
    local fanout_node_port=$(kubectl get svc rabbitmq-fanout -o=jsonpath='{.spec.ports[0].nodePort}'
    --namespace=${cluster_namespace})
    declare -A deployment_props
    deployment_props["ExternalIP"]=${external_ip}
    deployment_props["NodePortPublisher"]=${publisher_node_port}
    deployment_props["NodePortCompetingConsumer"]=${competing_consumer_node_port}
    deployment_props["NodePortDualChannel"]=${dual_channel_node_port}
    deployment_props["NodePortFanout"]=${fanout_node_port}
    write_to_properties_file ${output_dir}/deployment.properties deployment_props
    local is_debug_enabled=${infra_config["isDebugEnabled"]}
    if [ "${is_debug_enabled}" = "true" ]; then
        echo "ExternalIP: ${external_ip}"
        echo "NodePortPublisher: ${publisher_node_port}"
        echo "NodePortCompetingConsumer: ${competing_consumer_node_port}"
        echo "NodePortDualChannel: ${dual_channel_node_port}"
        echo "NodePortFanout: ${fanout_node_port}"
    fi
}

setup_deployment
