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

readonly dir_kafka=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)
readonly dir_messaging=$(dirname ${dir_kafka})
readonly dir_test_grid_scripts=$(dirname ${dir_messaging})
readonly dir_root=$(dirname ${dir_test_grid_scripts})

readonly dir_resources="${dir_root}/messaging/kafka/src/test/resources"
readonly test_dir="${dir_resources}/test-src/messaging-with-kafka"

. ${dir_test_grid_scripts}/common/usage.sh
. ${dir_test_grid_scripts}/setup/setup_deployment_env.sh

function setup_deployment() {
  set_bal_path
  replace_variables_in_files
  deploy_kafka_cluster
  build_and_deploy_resources
  print_kubernetes_debug_info
  wait_for_pod_readiness
  retrieve_and_write_properties_to_data_bucket
#  local is_debug_enabled=${infra_config["isDebugEnabled"]}
#  if [ "${is_debug_enabled}" = "true" ]; then
#    print_kubernetes_debug_info
#  fi
}

function set_bal_path() {
  consumer_bal_path="${test_dir}/src/kafka-consumer/kafka-consumer.bal"
  producer_bal_path="${test_dir}/src/kafka-producer/kafka-producer.bal"
}

function replace_variables_in_files() {
  replace_variables_in_file ${consumer_bal_path}
  replace_variables_in_file ${producer_bal_path}
}

function replace_variables_in_file() {
  local bal_path=$1
  sed -i "s:<USERNAME>:${docker_user}:g" ${bal_path}
  sed -i "s:<PASSWORD>:${docker_password}:g" ${bal_path}
  sed -i "s:kafka.ballerina.io:${docker_user}:g" ${bal_path}
}

function deploy_kafka_cluster() {
  kubectl create -f ${dir_resources}/kubernetes-configs/zookeeper-deployment.yaml --namespace=${cluster_namespace}
  kubectl create -f ${dir_resources}/kubernetes-configs/zookeeper-service.yaml --namespace=${cluster_namespace}

  wait_for_pod_readiness

  kubectl create -f ${dir_resources}/kubernetes-configs/kafka-service.yaml --namespace=${cluster_namespace}
  kubectl create -f ${dir_resources}/kubernetes-configs/kafka-deployment.yaml --namespace=${cluster_namespace}

  wait_for_pod_readiness
}

function build_and_deploy_resources() {
  # shellcheck disable=SC2164
  cd ${test_dir}
  ls -la
  ${ballerina_home}/bin/ballerina -v
  ${ballerina_home}/bin/ballerina build --all
  cd ${dir_root}
  kubectl apply -f ${test_dir}/target/kubernetes/kafka-consumer --namespace=${cluster_namespace}
  kubectl apply -f ${test_dir}/target/kubernetes/kafka-producer --namespace=${cluster_namespace}
}

function retrieve_and_write_properties_to_data_bucket() {
    local external_ip=$(kubectl get nodes --namespace=${cluster_namespace} -o=jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
    local node_port_consumer=$(kubectl get svc kafka-consumer-http-service --namespace=${cluster_namespace} -o=jsonpath='{.spec.ports[0].nodePort}')
    local node_port_producer=$(kubectl get svc kafka-producer-http-service --namespace=${cluster_namespace} -o=jsonpath='{.spec.ports[0].nodePort}')

    declare -A deployment_props

    deployment_props["ExternalIP"]=${external_ip}
    deployment_props["NodePortConsumer"]=${node_port_consumer}
    deployment_props["NodePortProducer"]=${node_port_producer}

    echo "****************************"
    echo ${node_port_consumer}
    echo ${node_port_producer}
    echo "****************************"

    write_to_properties_file ${output_dir}/deployment.properties deployment_props
    local is_debug_enabled=${infra_config["isDebugEnabled"]}
    if [ "${is_debug_enabled}" = "true" ]; then
        echo "ExternalIP: ${external_ip}"
        echo "Consumer NodePort: ${node_port_consumer}"
        echo "Producer NodePort: ${node_port_producer}"
    fi
}

function print_kubernetes_debug_info() {
    kubectl get pods --namespace=${cluster_namespace}
    kubectl get nodes --namespace=${cluster_namespace} --output wide

#    kubectl describe pods --namespace=${cluster_namespace}
}

setup_deployment
