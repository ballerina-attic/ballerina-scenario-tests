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
import ballerina/time;
import ballerinax/java.jdbc;

jdbc:Client testDB =  new jdbc:Client({
        url: config:getAsString("database.postgresql.test.jdbc.url"),
        username: config:getAsString("database.postgresql.test.jdbc.username"),
        password: config:getAsString("database.postgresql.test.jdbc.password")
    });

type IntegerType record {
    int id;
    int? smallIntVal;
    int? intVal;
    int? bigIntVal;
};

type FixedPointType record {
    int id;
    decimal? numericVal;
    decimal? decimalVal;
};

type FloatingPointType record {
    int id;
    float? realVal;
    float? doubleVal;
};

type StringType record {
    int id;
    string? varcharVal;
    string? textVal;
};

type DateTimeTypeStr record {
    string? dateStr;
    string? timeStr;
    string? timezStr;
    string? timestampStr;
    string? timestampzStr;
};

type DateTimeTypeInt record {
    int? dateInt;
    int? timeInt;
    int? timezInt;
    int? timestampInt;
    int? timestampzInt;
};

type DateTimeTypeRec record {
    time:Time? dateRec;
    time:Time? timeRec;
    time:Time? timezRec;
    time:Time? timestampRec;
    time:Time? timestampzRec;
};

type ComplexType record {
    int id;
    byte[]|() binaryVal;
};

function testUpdateIntegerTypesWithValues() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_TEST_INTEGER_TYPES", 1, 32765, 8388603, 2147483644);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_INTEGER_TYPES", 1, IntegerType);

    return [updateRet, selectRet];
}

function testUpdateIntegerTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32765 };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 8388603 };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 2147483644 };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_TEST_INTEGER_TYPES", id, smallIntVal, intVal, bigIntVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_INTEGER_TYPES", 2, IntegerType);

    return [updateRet, selectRet];
}

function testUpdateFixedPointTypesWithValues() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", 1, 1034.789, 15678.9845);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", 1, FixedPointType);

    return [updateRet, selectRet];
}

function testUpdateFixedPointTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1034.789 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 15678.9845 };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", id, numericVal, decimalVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", 2, FixedPointType);

    return [updateRet, selectRet];
}

function testUpdateFloatingPointTypesWithValues() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_TEST_FLOAT_TYPES", 1, 999.12569, 109999.1234123789145);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_FLOAT_TYPES", 1, FloatingPointType);

    return [updateRet, selectRet];
}

function testUpdateFloatingPointTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter realVal = { sqlType: jdbc:TYPE_NUMERIC, value: 999.12569 };
    jdbc:Parameter doubleVal = { sqlType: jdbc:TYPE_DECIMAL, value: 109999.1234123789145 };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_TEST_FLOAT_TYPES", id, realVal, doubleVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_FLOAT_TYPES", 2, FloatingPointType);

    return [updateRet, selectRet];
}

function testUpdateStringTypesWithValues() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_TEST_STRING_TYPES", 1, "Varchar column", "Text column");
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_STRING_TYPES", 1, StringType);

    return [updateRet, selectRet];
}

function testUpdateStringTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column" };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_LONGVARCHAR, value: "Text column" };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_TEST_STRING_TYPES", id, varcharVal, textVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_STRING_TYPES", 2, StringType);

    return [updateRet, selectRet];
}

function testUpdateComplexTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_TEST_COMPLEX_TYPES", id, binaryVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_COMPLEX_TYPES", 2, ComplexType);

    return [updateRet, selectRet];
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

function runSelectSetQuery(string tableName, int id, typedesc<record{}> recordType, string... fields) returns @tainted record{} | error {
    string fieldString = fields[0];
    if (fields.length() > 1) {
        int i = 1;
        while(i < fields.length()) {
            fieldString += ("," + fields[i]);
            i = i + 1;
        }
    }
    string queryStr = "SELECT " + fieldString + " FROM " + tableName + " WHERE ID = ?";
    table<record{}> | error returnedTable = testDB->select(queryStr, recordType, id);

    record {} returnedRecord;
    if (returnedTable is table<record{}>) {
        foreach var entry in returnedTable {
            returnedRecord = entry;
        }
    } else {
        return returnedTable;
    }
    return returnedRecord;
}

function runSelectAllQuery(string tableName, int id, typedesc<record{}> recordType) returns @tainted record{} | error {
    return runSelectSetQuery(tableName, id, recordType, "*");
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}






