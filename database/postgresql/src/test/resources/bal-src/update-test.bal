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

jdbc:Client testDB =  new jdbc:Client({
        url: config:getAsString("database.postgresql.test.jdbc.url"),
        username: config:getAsString("database.postgresql.test.jdbc.username"),
        password: config:getAsString("database.postgresql.test.jdbc.password")
    });

function testUpdateIntegerTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_INTEGER_TYPES", 1, 32765, 8388603, 2147483644);
}

function testUpdateIntegerTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32765 };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 8388603 };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 2147483644 };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_INTEGER_TYPES", id, smallIntVal, intVal, bigIntVal);
}

function testUpdateFixedPointTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", 1, 1034.789, 15678.9845);
}

function testUpdateFixedPointTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1034.789 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 15678.9845 };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", id, numericVal, decimalVal);
}

function testUpdateStringTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_STRING_TYPES", 1, "Varchar column", "Text column");
}

function testUpdateStringTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column" };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_LONGVARCHAR, value: "Text column" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_STRING_TYPES", id, varcharVal, textVal);
}

function testUpdateComplexTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_COMPLEX_TYPES", 1, "QmluYXJ5IENvbHVtbg==");
}

function testUpdateComplexTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    return runInsertQueryWithParams("SELECT_UPDATE_TEST_COMPLEX_TYPES", id, binaryVal);
}

function testUpdateDateTimeWithValues() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-03-27-08:01" };
    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999" };
    jdbc:Parameter timezVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999+08:33" };
    jdbc:Parameter timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };
    jdbc:Parameter timestampzVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_DATETIME_TYPES", id, dateVal, timeVal, timezVal, timestampVal,
        timestampzVal);
}

function testGeneratedKeyOnInsert() returns jdbc:UpdateResult | error {
    return testDB->update("INSERT INTO UPDATE_TEST_GENERATED_KEYS (COL1, COL2) VALUES ('abc', 92)");
}

function testGeneratedKeyOnInsertEmptyResults() returns jdbc:UpdateResult | error {
    return testDB->update("INSERT INTO UPDATE_TEST_GENERATED_KEYS_NO_KEY (COL1, COL2) VALUES ('xyz', 24)");
}

function runInsertQueryWithValues(string tableName, (int | float | string | byte[])... parameters)
             returns jdbc:UpdateResult | error {
    int paramLength = parameters.length();
    string paramString = "";
    if (paramLength >= 1) {
        paramString += "?";
    }
    if (paramLength > 1) {
        int i = 1;
        while (i < paramLength) {
            paramString += ", ?";
            i = i + 1;
        }
    }
    return testDB->update("INSERT INTO " + tableName + " VALUES(" + paramString + ")", ...parameters);
}


function runInsertQueryWithParams(string tableName, jdbc:Parameter... parameters)
             returns jdbc:UpdateResult | error {
    int paramLength = parameters.length();
    string paramString = "";
    if (paramLength >= 1) {
        paramString += "?";
    }
    if (paramLength > 1) {
        int i = 1;
        while (i < paramLength) {
            paramString += ", ?";
            i = i + 1;
        }
    }
    return testDB->update("INSERT INTO " + tableName + " VALUES(" + paramString + ")", ...parameters);
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}






