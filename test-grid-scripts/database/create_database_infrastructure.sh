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

# Possible formats:
# 1. DBType-DBEdition-DBVersion eg: MySQL-5.7
# 2. DBType-DBVersion eg: SQLServer-SE-13.00
db_engine=${db_details["DBEngine"]}

read database_type database_version <<<$(IFS="-"; echo ${db_engine})

read database_edition database_version <<<$(IFS="-"; echo ${database_version})

if [ ${database_type:-""} = "" ]; then
    echo "Database not provided!"
    exit 1
fi

if [ ${database_version:-""} = "" ]; then
    echo "Database version not provided!"
    exit 1
fi

database_type=${database_type}-${database_edition}

database_name=$(generate_random_db_name)

echo "Creating database..."
echo "Database details: DB_TYPE: ${database_type} | DB_VERSION:${database_version} | DB_NAME: ${database_name}"

if [ ${database_type} = "MySQL" ]; then
    create_database ${database_type} ${database_version} ${database_name} "db.t2.micro" 10 database_host
    echo "DB Host: ${database_host}"
    #mysql -h "${database_host}" -P 3306 -u 'masterawsuser' -p'masteruserpassword' <${database_parent_path}/db_init.sql
    jdbc_url="jdbc:mysql://${database_host}:3306"
    echo "database.mysql.test.jdbc.url=${jdbc_url}" >> ${output_dir}/infrastructure.properties
    echo "database.mysql.test.jdbc.username=masterawsuser" >> ${output_dir}/infrastructure.properties
    echo "database.mysql.test.jdbc.password=masteruserpassword" >> ${output_dir}/infrastructure.properties
    echo "TestGroup=mysql" >> ${output_dir}/infrastructure.properties
    echo "DatabaseName=${database_name}" >> ${output_dir}/infrastructure-cleanup.properties
elif [ ${database_type} = "Postgres" ]; then
    create_database ${database_type} ${database_version} ${database_name} "db.t2.micro" 10 database_host
    echo "DB Host: ${database_host}"
    #sudo apt-get install -y postgresql-client
    #PGPASSWORD=masteruserpassword psql -h "${database_host}" -p 5432 --username 'masterawsuser' -d postgres < ${database_parent_path}/db_init.sql
    jdbc_url="jdbc:postgresql://${database_host}:5432"
    echo "database.postgresql.test.jdbc.url=${jdbc_url}" >> ${output_dir}/infrastructure.properties
    echo "database.postgresql.test.jdbc.username=masterawsuser" >> ${output_dir}/infrastructure.properties
    echo "database.postgresql.test.jdbc.password=masteruserpassword" >> ${output_dir}/infrastructure.properties
    echo "TestGroup=postgresql" >> ${output_dir}/infrastructure.properties
    echo "DatabaseName=${database_name}" >> ${output_dir}/infrastructure-cleanup.properties
elif [ ${database_type} = "SQLServer-SE" ]; then
    # Temp fix until XE is added to testgrid
    database_type="SQLServer-EX"
    create_database ${database_type} ${database_version} ${database_name} "db.t2.micro" 20 database_host
    echo "DB Host: ${database_host}"
    jdbc_url="jdbc:sqlserver://${database_host}:1433"
    echo "database.mssql.test.jdbc.url=${jdbc_url}" >> ${output_dir}/infrastructure.properties
    echo "database.mssql.test.jdbc.username=masterawsuser" >> ${output_dir}/infrastructure.properties
    echo "database.mssql.test.jdbc.password=masteruserpassword" >> ${output_dir}/infrastructure.properties
    echo "TestGroup=mssql" >> ${output_dir}/infrastructure.properties
    echo "DatabaseName=${database_name}" >> ${output_dir}/infrastructure-cleanup.properties
elif [ ${database_type} = "Oracle-SE1" ]; then
    create_database ${database_type} ${database_version} ${database_name} "db.t2.micro" 20 database_host
    echo "DB Host: ${database_host}"
    jdbc_url="jdbc:oracle:thin//${database_host}:1521"
    echo "database.oracle.test.jdbc.url=${jdbc_url}" >> ${output_dir}/infrastructure.properties
    echo "database.oracle.test.jdbc.username=masterawsuser" >> ${output_dir}/infrastructure.properties
    echo "database.oracle.test.jdbc.password=masteruserpassword" >> ${output_dir}/infrastructure.properties
    echo "TestGroup=oracle" >> ${output_dir}/infrastructure.properties
    echo "DatabaseName=${database_name}" >> ${output_dir}/infrastructure-cleanup.properties
fi
