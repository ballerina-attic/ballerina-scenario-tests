#!/bin/bash
# Copyright (c) 2020, WSO2 Inc. (http://wso2.com) All Rights Reserved.
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
    echo "Host And Ports: ${external_ip}:${publisher_node_port}, ${competing_consumer_node_port}"
}

function run_tests() {
    local external_ip=${deployment_config["ExternalIP"]}
    local publisher_node_port=${deployment_config["NodePortPublisher"]}
    local competing_consumer_node_port=${deployment_config["NodePortCompetingConsumer"]}
    local dual_channel_node_port=${deployment_config["NodePortDualChannel"]}
    local fanout_node_port=${deployment_config["NodePortFanout"]}

    local is_debug_enabled=${deployment_config["isDebugEnabled"]}
    if [ "${is_debug_enabled}" = "true" ]; then
        print_debug_info
    fi

    declare -A sys_prop_array
    sys_prop_array["rabbitmq.service.host"]=${external_ip}
    sys_prop_array["rabbitmq.service.port.publisher"]=${publisher_node_port}
    sys_prop_array["rabbitmq.service.port.competing.consumer"]=${competing_consumer_node_port}
    sys_prop_array["rabbitmq.service.port.dual.channel"]=${dual_channel_node_port}
    sys_prop_array["rabbitmq.service.port.fanout"]=${fanout_node_port}

    # Builds and run tests of the given connector section and copies resulting surefire reports to output directory
    run_scenario_tests rabbitmq messaging rabbitmq sys_prop_array ${input_dir} ${output_dir} "RabbitMQConnector"
}

run_tests
