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
    url: config:getAsString("database.oracle.test.jdbc.url"),
    username: config:getAsString("database.oracle.test.jdbc.username"),
    password: config:getAsString("database.oracle.test.jdbc.password")
});

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

function testUpdateIntegerTypesWithValues() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_INTEGER_TYPES", 1, 9223372036854775807);//9223372036854775805);

    var selectRet = runSelectAllQuery("SELECT_UPDATE_INTEGER_TYPES", 1, IntegerType);
    return [updateRet, selectRet];
}

function testUpdateIntegerTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 1234 };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_INTEGER_TYPES", id, intVal);

    var selectRet = runSelectAllQuery("SELECT_UPDATE_INTEGER_TYPES", 2, IntegerType);
    return [updateRet, selectRet];
}

function testUpdateFloatingPointTypesWithValues() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_FLOAT_TYPES", 1, 999.125698, 109999.123412378914545);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_FLOAT_TYPES", 1, FloatingPointType);

    return [updateRet, selectRet];
}

function testUpdateFloatingPointTypesWithParams() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 999.125698 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 109999.123412378914545 };

    return runInsertQueryWithParams("SELECT_UPDATE_FLOAT_TYPES", id, numericVal, decimalVal);
}

function testUpdateFixedPointTypesWithValues() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_FIXEDPOINT_TYPES", 1, 123.12, 123.12);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_FIXEDPOINT_TYPES", 1, FixedPointType);

    return [updateRet, selectRet];
}

function testUpdateFixedPointTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 123.12 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 123.12 };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_FIXEDPOINT_TYPES", id, numericVal, decimalVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_FIXEDPOINT_TYPES", 2, FixedPointType);

    return [updateRet, selectRet];
}

function testUpdateStringTypesWithValues() @tainted [jdbc:UpdateResult|error, record{}|error] {
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_STRING_TYPES", 1, "Char column", "යූනිකෝඩ් දත්ත",
    "Varchar column", "යූනිකෝඩ් දත්ත");
    var selectRet = runSelectAllQuery("SELECT_UPDATE_STRING_TYPES", 1, StringType);

    return [updateRet, selectRet];
}

function testUpdateStringTypesWithParams() @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, value: "Char Column" };
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, value: "යූනිකෝඩ් දත්ත" };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column" };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, value: "යූනිකෝඩ් දත්ත" };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_STRING_TYPES", id, charVal, ncharVal, varcharVal, nvarcharVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_STRING_TYPES", 1, StringType);

    return [updateRet, selectRet];
}

function testUpdateComplexTypesWithValues() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    var updateRet = runInsertQueryWithValues("SELECT_UPDATE_COMPLEX_TYPES", 1, "426c6f6220436f6c756d6e", "Clob Column", "යූනිකෝඩ් දත්ත");
    var selectRet = runSelectAllQuery("SELECT_UPDATE_COMPLEX_TYPES", 1, ComplexType);

    return [updateRet, selectRet];
}

function testUpdateComplexTypesWithParams() returns @tainted [jdbc:UpdateResult|error, record{}|error] {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter blobVal =  { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4=" };
    jdbc:Parameter clobVal = { sqlType: jdbc:TYPE_CLOB, value: "Clob Column" };
    jdbc:Parameter nclobVal = { sqlType: jdbc:TYPE_NCLOB, value: "යූනිකෝඩ් දත්ත" };

    var updateRet = runInsertQueryWithParams("SELECT_UPDATE_COMPLEX_TYPES", id, blobVal, clobVal, nclobVal);
    var selectRet = runSelectAllQuery("SELECT_UPDATE_COMPLEX_TYPES", 2, ComplexType);

    return [updateRet, selectRet];
}

function testUpdateDateTimeWithValuesParam() returns jdbc:UpdateResult | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-03-27-08:01" };
    jdbc:Parameter timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1948-02-04T01:05:15.999-08:00" };
    jdbc:Parameter timestampTzVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };
    jdbc:Parameter timestampTzLocalVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };

    return runInsertQueryWithParams("SELECT_UPDATE_DATETIME_TYPES", id, dateVal, timestampVal, timestampTzVal, timestampTzLocalVal);
}

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

function runSelectAllQuery(string tableName, int id, typedesc<record{}> recordType) returns @tainted record{} | error {
    return runSelectSetQuery(tableName, id, recordType, "*");
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

function stopDatabaseClient() {
    checkpanic testDB.stop();
}
