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

readonly test_utils_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
readonly test_grid_scripts_dir=$(dirname ${test_utils_dir})
readonly root_dir=$(dirname ${test_grid_scripts_dir})

# Builds run tests of the provided BBG section profile and copies the surefire reports to teh output directory
#
# $1 - Maven profile to be run
# $2 - Test section (Eg.: "bbg" or "connectors" or "http")
# $3 - Test name (Eg.: "kafka" or, "artemis" or "resiliency")
# $4 - Associative array of system property-value pairs
# $5 - Input directory
# $6 - Output directory
# $7 - Test group name
run_scenario_tests() {
    local maven_profile=$1
    local section=$2
    local test_name=$3
    local -n properties_array=$4
    local __input_dir=$5
    local __output_dir=$6
    local test_group=$7
    local sys_prop_str=""
    bash --version
    for x in "${!properties_array[@]}"; do sys_prop_str+="-D$x=${properties_array[$x]} " ; done

    mvn -B clean install -f ${root_dir}/pom.xml -fae -Ddata.bucket.location=${__input_dir} ${sys_prop_str} -Dtestng.groups=${test_group} -P ${maven_profile}

    mkdir -p ${__output_dir}/scenarios/${test_name}
    cp -r ${root_dir}/${section}/${test_name}/target ${__output_dir}/scenarios/${test_name}/
}

# Builds run tests of the provided BBG section profile and copies the surefire reports to teh output directory
#
# $1 - Maven profile to be run
# $2 - Associative array of system property-value pairs
# $3 - System properties associative array
# $4 - Input directory
# $5 - Output directory
run_bbg_section_tests() {
    local maven_profile=$1
    local bbg_section=$2
    local -n properties_array=$3
    local __input_dir=$4
    local __output_dir=$5
    local test_group=$6
    local sys_prop_str=""
    bash --version
    for x in "${!properties_array[@]}"; do sys_prop_str+="-D$x=${properties_array[$x]} " ; done

    mvn clean install -f ${root_dir}/pom.xml -fae -Ddata.bucket.location=${__input_dir} ${sys_prop_str} -Dtestng.groups=${test_group} -P ${maven_profile}

    mkdir -p ${__output_dir}/scenarios

    cp -r ${root_dir}/bbg/${bbg_section}/target ${__output_dir}/scenarios/${bbg_section}/
}

run_connector_section_tests() {
    local maven_profile=$1
    local connector_section=$2
    local -n properties_array=$3
    local __input_dir=$4
    local __output_dir=$5
    local test_group=$6
    local sys_prop_str=""
    bash --version
    for x in "${!properties_array[@]}"; do sys_prop_str+="-D$x=${properties_array[$x]} " ; done

    mvn clean install -f ${root_dir}/pom.xml -fae -Ddata.bucket.location=${__input_dir} ${sys_prop_str} -Dtestng.groups=${test_group} -P ${maven_profile}

    mkdir -p ${__output_dir}/scenarios

    cp -r ${root_dir}/connectors/${connector_section}/target ${__output_dir}/scenarios/${connector_section}/
}
