#!/usr/bin/env bash

set -o xtrace

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
grand_parent_path=$(dirname ${parent_path})

. ${grand_parent_path}/util/infra_utils.sh
. ${grand_parent_path}/util/database_utils.sh

echo "Resource deletion script is being executed !"
input_dir=${2}

# Read infrastucture cleanup properties to a associative array
declare -A infra_cleanup_config
read_infra_cleanup_props ${input_dir} infra_cleanup_config

db_identifier=${infra_cleanup_config[DatabaseName]}
delete_database ${db_identifier}
