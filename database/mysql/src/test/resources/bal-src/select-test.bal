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
import ballerina/io;
import ballerina/sql;
import ballerina/time;
import ballerinax/jdbc;

type NumericType record {
    int id;
    boolean? bitVal;
    int? tinyIntVal;
    int? smallIntVal;
    int? mediumIntVal;
    int? intVal;
    int? bigIntVal;
    decimal? decimalVal;
    decimal? numericVal;
};

type FloatingPointType record {
    int id;
    float? floatVal;
    float? doubleVal;
};

type StringType record {
    int id;
    string? charVal;
    string? varcharVal;
    string? tinyTextVal;
    string? textVal;
    string? mediumTextVal;
    string? longTextVal;
    string? setVal;
    string? enumVal;
};

type DateTimeTypeStr record {
   string? dateStr;
   string? timeStr;
   string? dateTimeStr;
   string? timestampStr;
};

type DateTimeTypeInt record {
    int? dateInt;
    int? timeInt;
    int? dateTimeInt;
    int? timestampInt;
    int? yearInt;
};

type DateTimeTypeRec record {
    time:Time? dateRec;
    time:Time? timeRec;
    time:Time? dateTimeRec;
    time:Time? timestampRec;
    int? yearInt;
};

type ComplexType record {
    int id;
    byte[]|() binaryVal;
    byte[]|() varBinaryVal;
    byte[]|() tinyBlobVal;
    byte[]|() blobVal;
    byte[]|() mediumBlobVal;
    byte[]|() longBlobVal;
};

jdbc:Client testDB = new({
      url: config:getAsString("database.mysql.test.jdbc.url"),
      username: config:getAsString("database.mysql.test.jdbc.username"),
      password: config:getAsString("database.mysql.test.jdbc.password")
});

const string DATE_VAL = "DATE_VAL";
const string TIME_VAL = "TIME_VAL";
const string DATETIME_VAL = "DATETIME_VAL";
const string TIMESTAMP_VAL = "TIMESTAMP_VAL";
const string YEAR_VAL = "YEAR_VAL";

function testSelectNumericTypes() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_NUMERIC_TYPES", "1", NumericType);
}

function testSelectNumericTypesNil() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_NUMERIC_TYPES", "2", NumericType);
}

function testSelectFloatTypes() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_FLOAT_TYPES", "1", FloatingPointType);
}

function testSelectFloatTypesNil() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_FLOAT_TYPES", "2", FloatingPointType);
}

function testSelectStringTypes() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_STRING_TYPES", "1", StringType);
}

function testSelectStringTypesNil() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_STRING_TYPES", "2", StringType);
}

function testDateTimeTypesString() returns record{} | error {
    return runSelectSetQuery("SELECT_UPDATE_TEST_DATETIME_TYPES", "1", DateTimeTypeStr, DATE_VAL, TIME_VAL,
        DATETIME_VAL, TIMESTAMP_VAL);
}

function testDateTimeTypesInt() returns record{} | error {
    return runSelectSetQuery("SELECT_UPDATE_TEST_DATETIME_TYPES", "1", DateTimeTypeInt, DATE_VAL, TIME_VAL,
        DATETIME_VAL, TIMESTAMP_VAL, YEAR_VAL);
}

function testDateTimeTypesNil() returns record{} | error {
    return runSelectSetQuery("SELECT_UPDATE_TEST_DATETIME_TYPES", "2", DateTimeTypeInt, DATE_VAL, TIME_VAL,
        DATETIME_VAL, TIMESTAMP_VAL, YEAR_VAL);
}

function testDateTimeTypesRecord() returns record{} | error {
    return runSelectSetQuery("SELECT_UPDATE_TEST_DATETIME_TYPES", "3", DateTimeTypeRec, DATE_VAL, TIME_VAL,
DATETIME_VAL, TIMESTAMP_VAL, YEAR_VAL);
}

function testComplexTypes() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_COMPLEX_TYPES", "1", ComplexType);
}

function testComplexTypesNil() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_COMPLEX_TYPES", "2", ComplexType);
}

function setUpDatetimeData(int date, int time, int datetime, int timestamp) {
   string stmt =
   "INSERT INTO SELECT_UPDATE_TEST_DATETIME_TYPES values (?,?,?,?,?,?)";
   int[] returnValues = [];

   sql:Parameter para1 = { sqlType: sql:TYPE_DATE, value: date };
   sql:Parameter para2 = { sqlType: sql:TYPE_TIME, value: time };
   sql:Parameter para3 = { sqlType: sql:TYPE_TIMESTAMP, value: datetime };
   sql:Parameter para4 = { sqlType: sql:TYPE_TIMESTAMP, value: timestamp };

   var insertRet = testDB->update(stmt, 1, para1, para2, para3, para4, 2019);
   if (insertRet is error) {
       anydata|error detailContent = insertRet.detail().message;
       string errorMessage = detailContent is string ? detailContent : "Error trace continues";
       error e = error("Setting up date time data failed: " + errorMessage);
       panic e;
   }
}

function setupDatetimeRecordData() returns (int, int, int, int) {
    int dateInserted = -1;
    int dateRetrieved = -1;
    int timeInserted = -1;
    int timeRetrieved = -1;
    int timestampInserted = -1;
    int timestampRetrieved = -1;
    int datetimeInserted = -1;
    int datetimeRetrieved = -1;
    time:Time dateRecord = checkpanic time:createTime(2017, 5, 23, 0, 0, 0, 0, "");

    time:TimeZone zoneValue = { id: "UTC" };
    time:Time timeRecord = { time: 51323000, zone: zoneValue };

    time:Time timestampRecord = checkpanic time:createTime(2017, 1, 25, 16, 12, 23, 0, "UTC");
    time:Time datetimeRecord = checkpanic time:createTime(2017, 1, 31, 16, 12, 23, 332, "UTC");
    dateInserted = dateRecord.time;
    timeInserted = timeRecord.time;
    timestampInserted = timestampRecord.time;
    datetimeInserted = datetimeRecord.time;

    sql:Parameter para0 = { sqlType: sql:TYPE_INTEGER, value: 3 };
    sql:Parameter para1 = { sqlType: sql:TYPE_DATE, value: dateRecord };
    sql:Parameter para2 = { sqlType: sql:TYPE_TIME, value: timeRecord };
    sql:Parameter para3 = { sqlType: sql:TYPE_DATETIME, value: datetimeRecord };
    sql:Parameter para4 = { sqlType: sql:TYPE_TIMESTAMP, value: timestampRecord };

    _ = checkpanic testDB->update("Insert into SELECT_UPDATE_TEST_DATETIME_TYPES values (?,?,?,?,?,?)",
        para0, para1, para2, para3, para4, 2019);
    return (dateInserted, timeInserted, datetimeInserted, timestampInserted);
}

function runSelectSetQuery(string tableName, string id, typedesc recordType, string... fields) returns record{} | error {
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
        io:println("table");
        foreach var entry in returnedTable {
            returnedRecord = entry;
        }
    } else {
        io:println("error");
        return returnedTable;
    }
    return returnedRecord;
}

function runSelectAllQuery(string tableName, string id, typedesc recordType) returns record{} | error {
    return runSelectSetQuery(tableName, id, recordType, "*");
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}
