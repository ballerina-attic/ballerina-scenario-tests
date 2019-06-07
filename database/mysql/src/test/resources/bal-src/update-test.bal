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

import ballerina/sql;
import ballerina/config;
import ballerinax/jdbc;

jdbc:Client testDB =  new jdbc:Client({
    url: config:getAsString("database.mysql.test.jdbc.url"),
    username: config:getAsString("database.mysql.test.jdbc.username"),
    password: config:getAsString("database.mysql.test.jdbc.password")
});

function testUpdateNumericTypesWithValues() returns sql:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_NUMERIC_TYPES", 1, 1, 126, 32765, 8388603, 2147483644, 2147483649, 143.78, 1034.789);
}

function testUpdateNumericTypesWithParams() returns sql:UpdateResult | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 2 };
    sql:Parameter bitVal = { sqlType: sql:TYPE_BIT, value: 1 };
    sql:Parameter tinyIntVal = { sqlType: sql:TYPE_TINYINT, value: 126 };
    sql:Parameter smallIntVal = { sqlType: sql:TYPE_SMALLINT, value: 32765 };
    sql:Parameter mediumIntVal = { sqlType: sql:TYPE_INTEGER, value: 32765 };
    sql:Parameter intVal = { sqlType: sql:TYPE_INTEGER, value: 8388603 };
    sql:Parameter bigIntVal = { sqlType: sql:TYPE_BIGINT, value: 2147483644 };
    sql:Parameter decimalVal = { sqlType: sql:TYPE_DECIMAL, value: 143.78 };
    sql:Parameter numericVal = { sqlType: sql:TYPE_NUMERIC, value: 1034.789 };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_NUMERIC_TYPES", id, bitVal, tinyIntVal, smallIntVal, mediumIntVal, intVal, bigIntVal, decimalVal, numericVal);
}

function testUpdateStringTypesWithValues() returns sql:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_STRING_TYPES", 1, "Char Column", "Varchar column", "TinyText column", "Text column", "MediumText column", "LongText column", "A", "X");
}

function testUpdateStringTypesWithParams() returns sql:UpdateResult | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter charVal = { sqlType: sql:TYPE_CHAR, value: "Char Column" };
    sql:Parameter varcharVal = { sqlType: sql:TYPE_VARCHAR, value: "Varchar column" };
    sql:Parameter tinyTextVal = { sqlType: sql:TYPE_LONGNVARCHAR, value: "TinyText column" };
    sql:Parameter textVal = { sqlType: sql:TYPE_LONGNVARCHAR, value: "Text column" };
    sql:Parameter mediumTextVal = { sqlType: sql:TYPE_CLOB, value: "MediumText column" };
    sql:Parameter longTextVal = { sqlType: sql:TYPE_CLOB, value: "LongText column" };
    sql:Parameter setVal = { sqlType: sql:TYPE_VARCHAR, value: "A" };
    sql:Parameter enumVal = { sqlType: sql:TYPE_VARCHAR, value: "X" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_STRING_TYPES", id, charVal, varcharVal, tinyTextVal, textVal, mediumTextVal, longTextVal, setVal, enumVal);
}

function testUpdateComplexTypesWithValues() returns sql:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_COMPLEX_TYPES", 1, "QmluYXJ5IENvbHVtbg==", "dmFyYmluYXJ5IENvbHVtbg==",
        "VGlueUJsb2IgQ29sdW1u", "QmxvYiBDb2x1bW4=", "TWVkaXVtQmxvYiBDb2x1bW4=", "TG9uZ0Jsb2IgQ29sdW1u");
}

function testUpdateComplexTypesWithParams() returns sql:UpdateResult | error {
    sql:Parameter id =  { sqlType: sql:TYPE_INTEGER, value: 2 };
    sql:Parameter binaryVal =  { sqlType: sql:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    sql:Parameter varBinaryVal = { sqlType: sql:TYPE_VARBINARY, value: "dmFyYmluYXJ5IENvbHVtbg==" };
    sql:Parameter tinyBlobVal = { sqlType: sql:TYPE_BLOB, value: "VGlueUJsb2IgQ29sdW1u" };
    sql:Parameter blobVal = { sqlType: sql:TYPE_BLOB, value: "QmxvYiBDb2x1bW4" };
    sql:Parameter mediumBlobVal = { sqlType: sql:TYPE_BLOB, value: "TWVkaXVtQmxvYiBDb2x1bW4=" };
    sql:Parameter longBlobVal = { sqlType: sql:TYPE_BLOB, value: "TG9uZ0Jsb2IgQ29sdW1u" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_COMPLEX_TYPES", id, binaryVal, varBinaryVal, tinyBlobVal, blobVal, mediumBlobVal, longBlobVal);
}

function testUpdateDateTimeWithValuesParam() returns sql:UpdateResult | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter dateVal = { sqlType: sql:TYPE_DATE, value: "2019-03-27-08:01" };
    sql:Parameter timeVal = { sqlType: sql:TYPE_TIME, value: "17:43:21.999999+08:33" };
    sql:Parameter dateTimeVal = { sqlType: sql:TYPE_TIMESTAMP, value: "1948-02-04T01:05:15.999-08:00" };
    sql:Parameter timestampVal = { sqlType: sql:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };
    sql:Parameter yearVal = { sqlType: sql:TYPE_INTEGER, value: "1991" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_DATETIME_TYPES", id, dateVal, timeVal, dateTimeVal, timestampVal, yearVal);
}

function testGeneratedKeyOnInsert() returns sql:UpdateResult | error {
    return testDB->update("INSERT INTO UPDATE_TEST_GENERATED_KEYS (COL1, COL2) VALUES ('abc', 92)");
}

function testGeneratedKeyOnInsertEmptyResults() returns sql:UpdateResult | error {
    return testDB->update("INSERT INTO UPDATE_TEST_GENERATED_KEYS_NO_KEY (COL1, COL2) VALUES ('xyz', 24)");
}

function runInsertQueryWithValues(string tableName, (int | float | string | byte[])... parameters)
returns sql:UpdateResult | error {
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


function runInsertQueryWithParams(string tableName, sql:Parameter... parameters)
returns sql:UpdateResult | error {
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
