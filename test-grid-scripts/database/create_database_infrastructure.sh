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

database_parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
database_grand_parent_path=$(dirname ${database_parent_path})

. ${database_grand_parent_path}/common/usage.sh
. ${database_grand_parent_path}/util/infra_utils.sh
. ${database_grand_parent_path}/util/database_utils.sh

set -o xtrace

echo "Reading database details from testplan-props.properties"
declare -A db_details
read_property_file ${output_dir}/testplan-props.properties db_details

db_engine=${db_details["DBEngine"]}

read database_type database_version <<<$(IFS="-"; echo ${db_engine})

if [ ${database_type:-""} = "" ]; then
    echo "Database not provided!"
    exit 1
fi

if [ ${database_version:-""} = "" ]; then
    echo "Database version not provided!"
    exit 1
fi

database_name=$(generate_random_db_name)

echo "Creating database..."
echo "Database details: DB_TYPE: ${database_type} | DB_VERSION:${database_version} | DB_NAME: ${database_name}"
create_database ${database_type} ${database_version} ${database_name} "db.t2.micro" database_host
echo "DB Host: ${database_host}"

if [ ${database_type} = "MySQL" ]; then
    mysql -h "${database_host}" -P 3306 -u 'masterawsuser' -p'masteruserpassword' <${database_parent_path}/db_init.sql
    jdbc_url="jdbc:mysql://${database_host}:3306/testdb"
    echo "database.mysql.test.jdbc.url=${jdbc_url}" >> ${output_dir}/infrastructure.properties
    echo "database.mysql.test.jdbc.username=masterawsuser" >> ${output_dir}/infrastructure.properties
    echo "database.mysql.test.jdbc.password=masteruserpassword" >> ${output_dir}/infrastructure.properties
    echo "TestGroup=mysql" >> ${output_dir}/infrastructure.properties
    echo "DatabaseName=${database_name}" >> ${output_dir}/infrastructure-cleanup.properties
fi
