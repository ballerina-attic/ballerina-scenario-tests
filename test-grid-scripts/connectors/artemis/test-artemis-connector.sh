#!/bin/bash

# Copyright (c) 2019, WSO2 Inc. (http://wso2.com) All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function print_debug_info() {
    echo "Host And Port: ${external_ip}:${node_port}"
}

function run_tests() {
    local external_ip=${deployment_config["ExternalIP"]}
    local node_port=${deployment_config["NodePort"]}

    local is_debug_enabled=${deployment_config["isDebugEnabled"]}
    if [ "${is_debug_enabled}" = "true" ]; then
        print_debug_info
    fi

    declare -A sys_prop_array
    sys_prop_array["artemis.service.host"]=${external_ip}
    sys_prop_array["artemis.service.port"]=${node_port}

    # Builds and run tests of the given connector section and copies resulting surefire reports to output directory
    run_connector_section_tests artemis artemis sys_prop_array ${input_dir} ${output_dir} "ArtemisConnector"
}

run_tests
