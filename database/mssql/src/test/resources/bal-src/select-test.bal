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

function testSelectIntegerTypes() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_INTEGER_TYPES", "1", IntegerType);
}

function testSelectIntegerTypesNil() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_INTEGER_TYPES", "2", IntegerType);
}

function testSelectFixedPointTypes() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", "1", FixedPointType);
}

function testSelectFixedPointTypesNil() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", "2", FixedPointType);
}

function testSelectFloatTypes() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_FLOAT_TYPES", "1", FloatingPointType);
}

function testSelectFloatTypesNil() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_FLOAT_TYPES", "2", FloatingPointType);
}

function testSelectStringTypes() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_STRING_TYPES", "1", StringType);
}

function testSelectStringTypesNil() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_STRING_TYPES", "2", StringType);
}

function testComplexTypes() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_COMPLEX_TYPES", "1", ComplexType);
}

function testComplexTypesNil() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_COMPLEX_TYPES", "2", ComplexType);
}

function testDateTimeTypes() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_DATETIME_TYPES", "3", DateTimeTypeStr);
}

function testDateTimeTypesNil() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_DATETIME_TYPES", "2", DateTimeTypeStr);
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

function setUpDatetimeData(int date, int time, int datetime, int datetime2, int smallDatetime, int dateTimeOffset) {
    string stmt = "INSERT INTO SELECT_UPDATE_TEST_DATETIME_TYPES values (?,?,?,?,?,?,?)";

    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 3 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: date };
    jdbc:Parameter dateTimeOffsetVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: dateTimeOffset };
    jdbc:Parameter dateTimeVal = { sqlType: jdbc:TYPE_DATETIME, value: datetime };
    jdbc:Parameter dateTime2Val = { sqlType: jdbc:TYPE_DATETIME, value: datetime2 };
    jdbc:Parameter smallDateTimeVal = { sqlType: jdbc:TYPE_DATETIME, value: smallDatetime };
    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, value: time };

    var insertRet = testDB->update(stmt, id, dateVal, dateTimeOffsetVal, dateTimeVal, dateTime2Val, smallDateTimeVal,
                                    timeVal);
    if (insertRet is error) {
       error err = insertRet;
       anydata|error detailContent = err.detail()["message"];
       string errorMessage = detailContent is string ? detailContent : "Error trace continues";
       error e = error("Setting up date time data failed: " + errorMessage);
       panic e;
    }
}

function runSelectAllQuery(string tableName, string id, typedesc<record{}> recordType) returns @tainted record{}|error {
    return runSelectSetQuery(tableName, id, recordType, "*");
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}
