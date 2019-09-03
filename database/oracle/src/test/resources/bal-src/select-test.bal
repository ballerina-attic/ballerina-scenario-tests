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

type IntegerType record {
    int id;
    int? intVal;
};

type FixedPointType record {
    int id;
    decimal? numericVal;
    decimal? decimalVal;
};

type FloatingPointType record {
    int id;
    float? binaryFloatVal;
    float? binaryDoubleVal;
};

type StringType record {
    int id;
    string? charVal;
    string? ncharVal;
    string? varcharVal;
    string? nvarcharVal;
};

type DateTimeTypeStr record {
    string? dateStr;
    string? timestampStr;
   // string? timestampzStr;
   // string? timestampzLocalStr;
};

type DateTimeTypeInt record {
    int? dateInt;
    int? timestampInt;
    //int? timestampzInt;
    //int? timestampzLocalInt;
};

type DateTimeTypeRec record {
    time:Time? dateRec;
    time:Time? timestampRec;
    //time:Time? timestampzRec;
    //time:Time? timestampzLocalRec;
};

type ComplexType record {
    int id;
    byte[]|() blobVal;
    string? clobVal;
    string? nclobVal;
};

const string DATE_VAL = "DATE_VAL";
const string TIMESTAMP_VAL = "TIMESTAMP_VAL";
const string TIMESTAMP_WITH_TZ_VAL = "TIMESTAMP_WITH_TZ_VAL";
const string TIMESTAMPZ_WITH_LOCAL_TZ_VAL = "TIMESTAMPZ_WITH_LOCAL_TZ_VAL";

jdbc:Client testDB = new({
        url: config:getAsString("database.oracle.test.jdbc.url"),
        username: config:getAsString("database.oracle.test.jdbc.username"),
        password: config:getAsString("database.oracle.test.jdbc.password")
    });

function testSelectIntegerTypes() returns @tainted record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_INTEGER_TYPES", 1, IntegerType);
}

function testSelectIntegerTypesNil() returns @tainted record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_INTEGER_TYPES", 2, IntegerType);
}

function testSelectFixedPointTypes() returns @tainted record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_FIXEDPOINT_TYPES", 1, FixedPointType);
}

function testSelectFixedPointTypesNil() returns @tainted record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_FIXEDPOINT_TYPES", 2, FixedPointType);
}

function testSelectFloatTypes() returns @tainted record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_FLOAT_TYPES", 1, FloatingPointType);
}

function testSelectFloatTypesNil() returns @tainted record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_FLOAT_TYPES", 2, FloatingPointType);
}

function testSelectStringTypes() returns @tainted record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_STRING_TYPES", 1, StringType);
}

function testSelectStringTypesNil() returns @tainted record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_STRING_TYPES", 2, StringType);
}

function testDateTimeTypesString() returns @tainted record{} | error {
    return runSelectSetQuery("SELECT_UPDATE_DATETIME_TYPES", 1, DateTimeTypeStr, DATE_VAL, TIMESTAMP_VAL);//,
}

function testDateTimeTypesInt() returns @tainted record{} | error {
    return runSelectSetQuery("SELECT_UPDATE_DATETIME_TYPES", 1, DateTimeTypeInt, DATE_VAL, TIMESTAMP_VAL);
}

function testDateTimeTypesNil() returns @tainted record{} | error {
    return runSelectSetQuery("SELECT_UPDATE_DATETIME_TYPES", 2, DateTimeTypeInt, DATE_VAL, TIMESTAMP_VAL);
}

function testDateTimeTypesRecord() returns @tainted record{} | error {
    return runSelectSetQuery("SELECT_UPDATE_DATETIME_TYPES", 1, DateTimeTypeRec, DATE_VAL, TIMESTAMP_VAL);
}

function testComplexTypes() returns @tainted record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_COMPLEX_TYPES", 1, ComplexType);
}

function testComplexTypesNil() returns @tainted record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_COMPLEX_TYPES", 2, ComplexType);
}

function setupDatetimeData() returns [int, int] {
    int dateInserted = -1;
    int timestampInserted = -1;
    time:Time dateRecord = checkpanic time:createTime(2017, 5, 23, 0, 0, 0, 0, "GMT+05:30");

    time:Time timestampRecord = checkpanic time:createTime(2017, 1, 25, 16, 12, 23, 0, "GMT+05:30");

    dateInserted = dateRecord.time;
    timestampInserted = timestampRecord.time;

    jdbc:Parameter para0 = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter para1 = { sqlType: jdbc:TYPE_DATE, value: dateRecord };
    // For TIMESTAMP type, user inserted zone details should be ignored. However, if user inserts an integer value,
    // then its up to him to drop any timezone info when obtaining that int value.
    jdbc:Parameter para2 = { sqlType: jdbc:TYPE_TIMESTAMP, value: timestampInserted };

    _ = checkpanic testDB->update("Insert into SELECT_UPDATE_DATETIME_TYPES (ID, DATE_VAL, TIMESTAMP_VAL)
    values (?,?,?)", para0, para1, para2);
    return [dateInserted, timestampInserted];
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

