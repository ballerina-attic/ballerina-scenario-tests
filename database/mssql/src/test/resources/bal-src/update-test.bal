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

type IntegerType record {
    int id;
    int? smallIntVal;
    int? bigIntVal;
    int? tinyIntVal;
    boolean? bitVal;
    int? intVal;
};

type FixedPointType record {
    int id;
    decimal? decimalVal;
    decimal? numericVal;
    decimal? moneyVal;
    decimal? smallMoneyVal;
};

type FloatingPointType record {
    int id;
    float? floatVal;
    float? realVal;
};

type StringType record {
    int id;
    string? charVal;
    string? varcharVal;
    string? textVal;
    string? ncharVal;
    string? nvarcharVal;
    string? ntextVal;
};

type ComplexType record {
    int id;
    byte[]|() binaryVal;
    byte[]|() varBinaryVal;
    byte[]|() imageVal;
};

type DateTimeTypeStr record {
    int id;
    string? dateVal;
    string? dateTimeOffsetVal;
    string? dateTimeVal;
    string? dateTime2Val;
    string? smallDateTimeVal;
    string? timeVal;
};

jdbc:Client testDB = new({
    url: config:getAsString("database.mssql.test.jdbc.url"),
    username: config:getAsString("database.mssql.test.jdbc.username"),
    password: config:getAsString("database.mssql.test.jdbc.password")
});

function testUpdateIntegerTypesWithValues() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    decimal dec = 922337203685477.5807;
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_TEST_INTEGER_TYPES", 1, 32767, 9223372036854775807, 255,
                                            1, 2147483647);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_INTEGER_TYPES", "1", IntegerType);
    return [updateRet, selectRet];
}

function testUpdateIntegerTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    decimal dec = 922337203685477.5807;
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32767 };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 9223372036854775807 };
    jdbc:Parameter tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, value: 255 };
    jdbc:Parameter bitVal = { sqlType: jdbc:TYPE_BIT, value: true };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 2147483647 };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_TEST_INTEGER_TYPES", id, smallIntVal, bigIntVal, tinyIntVal,
                        bitVal, intVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_INTEGER_TYPES", "2", IntegerType);
    return [updateRet, selectRet];
}

function testUpdateFixedPointTypesWithValues() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    decimal dec = 922337203685477.5807;
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", 1, 10.05, 1.051, dec, 214748.3647);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", "1", FixedPointType);
    return [updateRet, selectRet];
}

function testUpdateFixedPointTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    decimal dec = 922337203685477.5807;
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 10.05 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1.051 };
    jdbc:Parameter moneyVal = { sqlType: jdbc:TYPE_DECIMAL, value: dec };
    jdbc:Parameter smallMoneyVal = { sqlType: jdbc:TYPE_DECIMAL, value: 214748.3647 };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", id, decimalVal, numericVal,
                                              moneyVal, smallMoneyVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", "2", FixedPointType);
    return [updateRet, selectRet];
}

function testUpdateFloatTypesWithValues() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_TEST_FLOAT_TYPES", 1, 123.45678, 1234.567);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_FLOAT_TYPES", "1", FloatingPointType);
    return [updateRet, selectRet];
}

function testUpdateFloatTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter floatVal = { sqlType: jdbc:TYPE_FLOAT, value: 123.45678 };
    jdbc:Parameter realVal = { sqlType: jdbc:TYPE_REAL, value:  1234.567};

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_TEST_FLOAT_TYPES", id, floatVal, realVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_FLOAT_TYPES", "2", FloatingPointType);
    return [updateRet, selectRet];
}

function testUpdateStringTypesWithValues() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_TEST_STRING_TYPES", 1, "ABCD", "SQL Server VARCHAR",
                                             "This is test message", "MS", "0E984725Ac", "Text");
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_STRING_TYPES", "1", StringType);
    return [updateRet, selectRet];
}

function testUpdateStringTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, value: "ABCD" };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "SQL Server VARCHAR" };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "This is test message" };
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, value: "MS" };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, value: "0E984725Ac" };
    jdbc:Parameter ntextVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "Text" };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_TEST_STRING_TYPES", id, charVal, varcharVal, textVal,
                                              ncharVal, nvarcharVal, ntextVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_STRING_TYPES", "2", StringType);
    return [updateRet, selectRet];
}

function testUpdateComplexTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    jdbc:Parameter varBinaryVal = { sqlType: jdbc:TYPE_VARBINARY, value: "dmFyYmluYXJ5IENvbHVtbg==" };
    jdbc:Parameter imageVal = { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4" };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_TEST_COMPLEX_TYPES", id, binaryVal, varBinaryVal, imageVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_COMPLEX_TYPES", "2", ComplexType);
    return [updateRet, selectRet];
}

function testUpdateDateTimeWithValuesParam(int date, int time, int datetime, int datetime2, int smallDatetime,
                                        int dateTimeOffset) returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: date };
    jdbc:Parameter dateTimeOffsetVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: dateTimeOffset };
    jdbc:Parameter dateTimeVal = { sqlType: jdbc:TYPE_DATETIME, value: datetime };
    jdbc:Parameter dateTime2Val = { sqlType: jdbc:TYPE_DATETIME, value: datetime2 };
    jdbc:Parameter smallDateTimeVal = { sqlType: jdbc:TYPE_DATETIME, value: smallDatetime };
    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, value: time };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_TEST_DATETIME_TYPES", id, dateVal, dateTimeOffsetVal,
                                              dateTimeVal, dateTime2Val, smallDateTimeVal, timeVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_TEST_DATETIME_TYPES", "1", DateTimeTypeStr);
    return [updateRet, selectRet];
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

function runSelectSetQuery(string tableName, string id, typedesc<record{}> recordType, string... fields)
                                                                        returns @tainted record{}|error {
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

function runSelectAllQuery(string tableName, string id, typedesc<record{}> recordType) returns @tainted record{}|error {
    return runSelectSetQuery(tableName, id, recordType, "*");
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}
