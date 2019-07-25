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
    url: config:getAsString("database.mysql.test.jdbc.url"),
    username: config:getAsString("database.mysql.test.jdbc.username"),
    password: config:getAsString("database.mysql.test.jdbc.password")
});

function testUpdateNumericTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_NUMERIC_TYPES", 1, 1, 126, 32765, 8388603, 2147483644, 2147483649, 143.78, 1034.789);
}

function testUpdateNumericTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter bitVal = { sqlType: jdbc:TYPE_BIT, value: true };
    jdbc:Parameter tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, value: 126 };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32765 };
    jdbc:Parameter mediumIntVal = { sqlType: jdbc:TYPE_INTEGER, value: 32765 };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 8388603 };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 2147483644 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 143.78 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1034.789 };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_NUMERIC_TYPES", id, bitVal, tinyIntVal, smallIntVal, mediumIntVal, intVal, bigIntVal, decimalVal, numericVal);
}

function testUpdateStringTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_STRING_TYPES", 1, "Char Column", "Varchar column", "TinyText column", "Text column", "MediumText column", "LongText column", "A", "X");
}

function testUpdateStringTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, value: "Char Column" };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column" };
    jdbc:Parameter tinyTextVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "TinyText column" };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "Text column" };
    jdbc:Parameter mediumTextVal = { sqlType: jdbc:TYPE_CLOB, value: "MediumText column" };
    jdbc:Parameter longTextVal = { sqlType: jdbc:TYPE_CLOB, value: "LongText column" };
    jdbc:Parameter setVal = { sqlType: jdbc:TYPE_VARCHAR, value: "A" };
    jdbc:Parameter enumVal = { sqlType: jdbc:TYPE_VARCHAR, value: "X" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_STRING_TYPES", id, charVal, varcharVal, tinyTextVal, textVal, mediumTextVal, longTextVal, setVal, enumVal);
}

function testUpdateComplexTypesWithValues() returns jdbc:UpdateResult | error {
    return runInsertQueryWithValues("SELECT_UPDATE_TEST_COMPLEX_TYPES", 1, "QmluYXJ5IENvbHVtbg==", "dmFyYmluYXJ5IENvbHVtbg==",
        "VGlueUJsb2IgQ29sdW1u", "QmxvYiBDb2x1bW4=", "TWVkaXVtQmxvYiBDb2x1bW4=", "TG9uZ0Jsb2IgQ29sdW1u");
}

function testUpdateComplexTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    jdbc:Parameter varBinaryVal = { sqlType: jdbc:TYPE_VARBINARY, value: "dmFyYmluYXJ5IENvbHVtbg==" };
    jdbc:Parameter tinyBlobVal = { sqlType: jdbc:TYPE_BLOB, value: "VGlueUJsb2IgQ29sdW1u" };
    jdbc:Parameter blobVal = { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4" };
    jdbc:Parameter mediumBlobVal = { sqlType: jdbc:TYPE_BLOB, value: "TWVkaXVtQmxvYiBDb2x1bW4=" };
    jdbc:Parameter longBlobVal = { sqlType: jdbc:TYPE_BLOB, value: "TG9uZ0Jsb2IgQ29sdW1u" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_COMPLEX_TYPES", id, binaryVal, varBinaryVal, tinyBlobVal, blobVal, mediumBlobVal, longBlobVal);
}

function testUpdateDateTimeWithValuesParam() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-03-27-08:01" };
    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999+08:33" };
    jdbc:Parameter dateTimeVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1948-02-04T01:05:15.999-08:00" };
    jdbc:Parameter timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };
    jdbc:Parameter yearVal = { sqlType: jdbc:TYPE_INTEGER, value: "1991" };

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_DATETIME_TYPES", id, dateVal, timeVal, dateTimeVal, timestampVal, yearVal);
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
