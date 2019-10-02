#!/usr/bin/env bash

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

readonly test_database_parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
readonly test_database_grand_parent_path=$(dirname ${test_database_parent_path})
readonly test_database_great_grand_parent_path=$(dirname ${test_database_grand_parent_path})

. ${test_database_grand_parent_path}/common/usage.sh
. ${test_database_grand_parent_path}/setup/setup_test_env.sh

set -o xtrace

# Builds run tests of the provided database and copies the surefire reports to teh output directory
#
# $1 - database module to be run
run_database_module() {
    cat ${input_dir}/deployment.properties
    local module=$1
    mvn clean install -f ${test_database_great_grand_parent_path}/pom.xml -fae -Ddata.bucket.location=${input_dir} -P database-${module} || true

    mkdir -p ${output_dir}/scenarios

    cp -r ${test_database_great_grand_parent_path}/database/${module}/target ${output_dir}/scenarios/${module}/
}

download_and_install_oracle_driver() {
    wget https://testgrid-resources.s3.amazonaws.com/packer/Unix/ojdbc6.jar
    # The Apache Maven site states that 3.0.0-M1 is the current stable version of maven install plugin. Hence using the milestone.
    mvn org.apache.maven.plugins:maven-install-plugin:3.0.0-M1:install-file -Dfile=./ojdbc6.jar -DgroupId=oracle -DartifactId=ojdbc6 -Dversion=1.0.0 -Dpackaging=jar
    rm ./ojdbc6.jar
}

run_provided_test() {
    local test_group_to_run=${deployment_config["TestGroup"]}

    if [ "${test_group_to_run}" = "mysql" ]; then
        run_database_module mysql
    elif [ "${test_group_to_run}" = "postgresql" ]; then
        run_database_module postgresql
    elif [ "${test_group_to_run}" = "mssql" ]; then
        run_database_module mssql
    elif [ "${test_group_to_run}" = "oracle" ]; then
        download_and_install_oracle_driver
        run_database_module oracle
    fi
}

run_provided_test
