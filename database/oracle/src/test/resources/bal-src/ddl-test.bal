// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/config;
import ballerinax/java.jdbc;

jdbc:Client testDB = new({
        url: config:getAsString("database.oracle.test.jdbc.url"),
        username: config:getAsString("database.oracle.test.jdbc.username"),
        password: config:getAsString("database.oracle.test.jdbc.password")
    });

function testCreateTable() returns jdbc:UpdateResult | error {
    return testDB->update("CREATE TABLE DDL_TEST_CREATE_TABLE(X INT, Y VARCHAR(20))");
}

function testAlterTable() returns jdbc:UpdateResult | error {
    return testDB->update("ALTER TABLE DDL_TEST_ALTER_TABLE ADD Z INTEGER");
}

function testDropTable() returns jdbc:UpdateResult | error {
    return testDB->update("DROP TABLE DDL_TEST_DROP_TABLE");
}

function testCreateProcedure() returns jdbc:UpdateResult | error {
    return testDB->update("CREATE PROCEDURE DDL_TEST_CREATE_PROC (X IN NUMBER) IS BEGIN dbms_output.put_line(X); END");
}

function testDropProcedure() returns jdbc:UpdateResult | error {
    return testDB->update("DROP PROCEDURE DDL_TEST_DROPPING_PROC");
}

function testCreateIndex() returns jdbc:UpdateResult | error {
    return testDB->update("CREATE INDEX DDL_TEST_CREATING_INDEX ON DDL_TEST_TABLE(Y)");
}

function testDropIndex() returns jdbc:UpdateResult | error {
    return testDB->update("DROP INDEX DDL_TEST_DROP_INDEX");
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}
