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
    url: config:getAsString("database.oracle.test.jdbc.url"),
    username: config:getAsString("database.oracle.test.jdbc.username"),
    password: config:getAsString("database.oracle.test.jdbc.password")
});

function testUpdateNumericTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_INTEGER_TYPES", 1, 9223372036854775805);
}

function testUpdateNumericTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 9223372036854775805 };

    return runInsertQueryWithParams("SELECT_UPDATE_INTEGER_TYPES", id, intVal);
}

function testUpdateFixedPointTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_FIXEDPOINT_TYPES", 1, 123.12, 123.12);
}

function testUpdateFixedPointTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 123.12 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 123.12 };

    return runInsertQueryWithParams("SELECT_UPDATE_FIXEDPOINT_TYPES", id, numericVal, decimalVal);
}

function testUpdateStringTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_STRING_TYPES", 1, "Char column", "යූනිකෝඩ් දත්ත", "Varchar column", "යූනිකෝඩ් දත්ත");
}

function testUpdateStringTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, value: "Char Column" };
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, value: "යූනිකෝඩ් දත්ත" };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column" };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, value: "යූනිකෝඩ් දත්ත" };

    return runInsertQueryWithParams("SELECT_UPDATE_STRING_TYPES", id, charVal, ncharVal, varcharVal, nvarcharVal);
}

function testUpdateComplexTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_COMPLEX_TYPES", 1, "426c6f6220436f6c756d6e", "Clob Column", "යූනිකෝඩ් දත්ත");
}

function testUpdateComplexTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter blobVal =  { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4=" };
    jdbc:Parameter clobVal = { sqlType: jdbc:TYPE_CLOB, value: "Clob Column" };
    jdbc:Parameter nclobVal = { sqlType: jdbc:TYPE_NCLOB, value: "යූනිකෝඩ් දත්ත" };

    return runInsertQueryWithParams("SELECT_UPDATE_COMPLEX_TYPES", id, blobVal, clobVal, nclobVal);
}

//function testUpdateDateTimeWithValuesParam() returns jdbc:UpdateResult | error {
//    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
//    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-03-27-08:01" };
//    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999+08:33" };
//    jdbc:Parameter dateTimeVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1948-02-04T01:05:15.999-08:00" };
//    jdbc:Parameter timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };
//    jdbc:Parameter yearVal = { sqlType: jdbc:TYPE_INTEGER, value: "1991" };
//
//    return runInsertQueryWithParams("SELECT_UPDATE_TEST_DATETIME_TYPES", id, dateVal, timeVal, dateTimeVal, timestampVal, yearVal);
//}

function testGeneratedKeyOnInsert() returns jdbc:UpdateResult | error {
    return testDB->update("INSERT INTO UPDATE_GENERATED_KEYS (COL1) VALUES ('abc')");
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
