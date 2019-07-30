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
    url: config:getAsString("database.mssql.test.jdbc.url"),
    username: config:getAsString("database.mssql.test.jdbc.username"),
    password: config:getAsString("database.mssql.test.jdbc.password")
});

function testUpdateNumericTypesWithValues() returns jdbc:UpdateResult | error {
    decimal dec = 922337203685477.5807;
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_NUMERIC_TYPES", 1, 32767, 9223372036854775807, 255, 1,
        2147483647, 10.05, 1.051, dec, 214748.3647);
}

function testUpdateNumericTypesWithParams() returns jdbc:UpdateResult | error {
    decimal dec = 922337203685477.5807;
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32767 };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 9223372036854775807 };
    jdbc:Parameter tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, value: 126 };
    jdbc:Parameter bitVal = { sqlType: jdbc:TYPE_BIT, value: true };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 2147483647 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 10.05 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1.051 };
    jdbc:Parameter moneyVal = { sqlType: jdbc:TYPE_DECIMAL, value: dec };
    jdbc:Parameter smallMoneyVal = { sqlType: jdbc:TYPE_DECIMAL, value: 214748.3647 };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_NUMERIC_TYPES", id, smallIntVal, bigIntVal, tinyIntVal, bitVal,
        intVal, decimalVal, numericVal, moneyVal, smallMoneyVal);
}

function testUpdateFloatTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_FLOAT_TYPES", 1, 123.45678, 1234.567);
}

function testUpdateFloatTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter floatVal = { sqlType: jdbc:TYPE_FLOAT, value: 123.45678 };
    jdbc:Parameter realVal = { sqlType: jdbc:TYPE_REAL, value:  1234.567};

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_FLOAT_TYPES", id, floatVal, realVal);
}

function testUpdateStringTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_STRING_TYPES", 1, "ABCD", "SQL Server VARCHAR",
        "This is test message", "ああ", "ありがとうございまし", "Text");
}

function testUpdateStringTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, value: "ABCD" };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "SQL Server VARCHAR" };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "This is test message" };
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, value: "ああ" };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, value: "ありがとうございまし" };
    jdbc:Parameter ntextVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "Text" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_STRING_TYPES", id, charVal, varcharVal, textVal, ncharVal,
        nvarcharVal, ntextVal);
}

function testUpdateComplexTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    jdbc:Parameter varBinaryVal = { sqlType: jdbc:TYPE_VARBINARY, value: "dmFyYmluYXJ5IENvbHVtbg==" };
    jdbc:Parameter imageVal = { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_COMPLEX_TYPES", id, binaryVal, varBinaryVal, imageVal);
}

function testUpdateDateTimeWithValuesParam() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-03-27-08:01" };
    jdbc:Parameter dateTimeOffsetVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };
    jdbc:Parameter dateTimeVal = { sqlType: jdbc:TYPE_DATETIME, value: "2007-05-08T12:35:29.123-08:00" };
    jdbc:Parameter dateTime2Val = { sqlType: jdbc:TYPE_DATETIME, value: "2007-05-08T12:35:29.1234567+12:15" };
    jdbc:Parameter smallDateTimeVal = { sqlType: jdbc:TYPE_DATETIME, value: "2007-05-08T12:35:29.123" };
    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999+08:33" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_DATETIME_TYPES", id, dateVal, dateTimeOffsetVal, dateTimeVal,
        dateTime2Val, smallDateTimeVal, timeVal);
}

function testGeneratedKeyOnInsert() returns jdbc:UpdateResult | error {
    return testDB->update("INSERT INTO UPDATE_TEST_GENERATED_KEYS (COL1, COL2) VALUES ('abc', 92)");
}

function runInsertQueryWithValues(string tableName, (int | float | string | byte[] | decimal)... parameters)
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
