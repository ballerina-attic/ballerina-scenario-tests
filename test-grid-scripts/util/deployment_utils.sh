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

readonly utils_parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

readonly cluster_name="ballerina-testgrid-cluster-v2"

# Install the provided Ballerina version
#
# $1 - Ballerina version
install_ballerina() {
    local ballerina_version=$1
    wget https://product-dist.ballerina.io/downloads/${ballerina_version}/ballerina-${ballerina_version}.zip --quiet
    unzip -q ballerina-${ballerina_version}.zip -d ${utils_parent_path}
    ${utils_parent_path}/ballerina-${ballerina_version}/bin/ballerina version
    readonly ballerina_home=${utils_parent_path}/ballerina-${ballerina_version}
}

# Downloads and extracts the MySQL connector
#
# $1 - Download location
download_and_extract_mysql_connector() {
    local download_location=$1
    wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz --quiet

    tar -xzf mysql-connector-java-5.1.47.tar.gz --directory ${download_location}
}

# Generates a random namespace name
generate_random_namespace() {
    echo "kubernetes-namespace"-$(generate_random_name)
}

# Generates a random name
generate_random_database_name() {
    echo "test-database"-$(generate_random_name)
}

# Generates a random database name
generate_random_name() {
    local new_uuid=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
    echo ${new_uuid}
}

# Wait for pod readiness
wait_for_pod_readiness() {
    local timeout=300
    local interval=20
    bash ${utils_parent_path}/wait-for-pod-ready.sh ${timeout} ${interval}

    # Temporary sleep to check whether app eventually becomes ready..
    # Ideally there should have been a kubernetes readiness probe
    # which would make sure the "Ready" status would actually mean
    # the pod is ready to accept requests (app is ready) so the above
    # readiness script would suffice
    sleep 120s
}

# Clones the given BBG.
#
# $1 - BBG repository name
clone_bbg() {
    local bbg_repo=$1
    git clone https://github.com/ballerina-guides/${bbg_repo} --branch testgrid-onboarding
}

push_image_to_docker_registry() {
    local image=$1
    local tag=$2
    docker login --username=${docker_user} --password=${docker_password}
    docker push ${docker_user}/${image}:${tag}
}

build_docker_image() {
    local image=$1
    local tag=$2
    local image_location=$3
    docker build -t ${docker_user}/${image}:${tag} ${image_location}
}
