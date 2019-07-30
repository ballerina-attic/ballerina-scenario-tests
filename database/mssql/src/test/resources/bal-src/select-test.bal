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

type NumericType record {
    int id;
    int? smallIntVal;
    int? bigIntVal;
    int? tinyIntVal;
    boolean? bitVal;
    int? intVal;
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

function testSelectNumericTypes() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_NUMERIC_TYPES", "1", NumericType);
}

function testSelectNumericTypesNil() returns @tainted record{}|error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_NUMERIC_TYPES", "2", NumericType);
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
    return runSelectAllQuery("SELECT_UPDATE_TEST_DATETIME_TYPES", "1", DateTimeTypeStr);
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

function runSelectAllQuery(string tableName, string id, typedesc<record{}> recordType) returns @tainted record{}|error {
    return runSelectSetQuery(tableName, id, recordType, "*");
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}
