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

function testCallInParamIntegerTypes() returns @tainted error? {
    decimal dec = 922337203685477.5807;
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32767 };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 9223372036854775807 };
    jdbc:Parameter tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, value: 126 };
    jdbc:Parameter bitVal = { sqlType: jdbc:TYPE_BIT, value: true };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 2147483647 };

    var ret = testDB->call("{CALL CALL_TEST_IN_INTEGER_TYPES(?, ?, ?, ?, ?, ?)}", (), id, smallIntVal,
        bigIntVal, tinyIntVal, bitVal, intVal);

    if (ret is error?) {
        return ret;
    } else {
        error e = error("Unexpected return type: table");
        return e;
    }
}

function testCallOutParamIntegerTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter bitVal = { sqlType: jdbc:TYPE_BIT, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_INTEGER_TYPES(?, ?, ?, ?, ?, ?)}", (), id, smallIntVal,
        bigIntVal, tinyIntVal, bitVal, intVal);
    any[] outparamValues = [ smallIntVal.value, bigIntVal.value, tinyIntVal.value, bitVal.value, intVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamIntegerTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    decimal dec = 922337203685477.5807;
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2, direction: jdbc:DIRECTION_IN };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32767, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 9223372036854775807,
                                                            direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, value: 126, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter bitVal = { sqlType: jdbc:TYPE_BIT, value: true, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 2147483647, direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_INTEGER_TYPES(?, ?, ?, ?, ?, ?)}", (), id, smallIntVal,
        bigIntVal, tinyIntVal, bitVal, intVal);
    any[] outparamValues = [ smallIntVal.value, bigIntVal.value, tinyIntVal.value, bitVal.value, intVal.value ];
    return [ret, outparamValues];
}

function testCallInParamFixedPointTypes() returns @tainted error? {
    decimal dec = 922337203685477.5807;
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 10.05 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1.051 };
    jdbc:Parameter moneyVal = { sqlType: jdbc:TYPE_DECIMAL, value: dec };
    jdbc:Parameter smallMoneyVal = { sqlType: jdbc:TYPE_DECIMAL, value: 214748.3647 };

    var ret = testDB->call("{CALL CALL_TEST_IN_FIXED_POINT_TYPES(?, ?, ?, ?, ?)}", (), id, decimalVal, numericVal,
                                moneyVal, smallMoneyVal);
    if (ret is error?) {
        return ret;
    } else {
        error e = error("Unexpected return type: table");
        return e;
    }
}

function testCallOutParamFixedPointTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter moneyVal = { sqlType: jdbc:TYPE_DECIMAL, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter smallMoneyVal = { sqlType: jdbc:TYPE_DECIMAL, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_FIXED_POINT_TYPES(?, ?, ?, ?, ?)}", (), id, decimalVal, numericVal,
                                moneyVal, smallMoneyVal);
    any[] outparamValues = [ decimalVal.value, numericVal.value, moneyVal.value, smallMoneyVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamFixedPointTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    decimal dec = 922337203685477.5807;
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2, direction: jdbc:DIRECTION_IN };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 10.05, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1.051, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter moneyVal = { sqlType: jdbc:TYPE_DECIMAL, value: dec, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter smallMoneyVal = { sqlType: jdbc:TYPE_DECIMAL, value: 214748.3647, direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_FIXED_POINT_TYPES(?, ?, ?, ?, ?)}", (), id, decimalVal, numericVal,
                                moneyVal, smallMoneyVal);
    any[] outparamValues = [ decimalVal.value, numericVal.value, moneyVal.value, smallMoneyVal.value ];
    return [ret, outparamValues];
}

function testCallInParamFloatTypes() returns @tainted error? {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter floatVal = { sqlType: jdbc:TYPE_FLOAT, value: 123.45678 };
    jdbc:Parameter realVal = { sqlType: jdbc:TYPE_REAL, value:  1234.567};

    var ret = testDB->call("{CALL CALL_TEST_IN_FLOAT_TYPES(?, ?, ?)}", (), id, floatVal, realVal);

    if (ret is error?) {
        return ret;
    } else {
        error e = error("Unexpected return type: table");
        return e;
    }
}

function testCallOutParamFloatTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter floatVal = { sqlType: jdbc:TYPE_FLOAT, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter realVal = { sqlType: jdbc:TYPE_REAL, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_FLOAT_TYPES(?, ?, ?)}", (), id, floatVal, realVal);
    any[] outparamValues = [ floatVal.value, realVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamFloatTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter floatVal = { sqlType: jdbc:TYPE_FLOAT, value: 123.45678, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter realVal = { sqlType: jdbc:TYPE_REAL, value:  1234.567, direction: jdbc:DIRECTION_INOUT};

    var ret = testDB->call("{CALL CALL_TEST_INOUT_FLOAT_TYPES(?, ?, ?)}", (), id, floatVal, realVal);
    any[] outparamValues = [ floatVal.value, realVal.value ];
    return [ret, outparamValues];
}

function testCallInParamStringTypes() returns @tainted error? {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, value: "ABCD" };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "SQL Server VARCHAR" };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "This is test message" };
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, value: "MS" };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, value: "0E984725Ac" };
    jdbc:Parameter ntextVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "Text" };

    var ret = testDB->call("{CALL CALL_TEST_IN_STRING_TYPES(?, ?, ?, ?, ?, ?, ?)}", (), id, charVal,
        varcharVal, textVal, ncharVal, nvarcharVal, ntextVal);

    if (ret is error?) {
        return ret;
    } else {
        error e = error("Unexpected return type: table");
        return e;
    }
}

function testCallOutParamStringTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter ntextVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_STRING_TYPES(?, ?, ?, ?, ?, ?, ?)}", (), id, charVal, varcharVal,
                            textVal, ncharVal, nvarcharVal, ntextVal);
    any[] outparamValues = [ charVal.value, varcharVal.value, textVal.value, ncharVal.value,
                             nvarcharVal.value, ntextVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamStringTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, value: "ABCD", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "SQL Server VARCHAR",
                                  direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "This is test message",
                               direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, value: "MS", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, value: "0E984725Ac",
                                   direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter ntextVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "Text", direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_STRING_TYPES(?, ?, ?, ?, ?, ?, ?)}", (), id, charVal,
        varcharVal, textVal, ncharVal, nvarcharVal, ntextVal);
    any[] outparamValues = [ charVal.value, varcharVal.value, textVal.value, ncharVal.value, nvarcharVal.value,
                             ntextVal.value ];
    return [ret, outparamValues];
}

function testCallInParamDateTimeValues() returns @tainted error? {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: "2017-01-30-08:01" };
    jdbc:Parameter dateTimeOffsetVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "2017-01-30T13:27:01.999-08:00" };
    jdbc:Parameter dateTimeVal = { sqlType: jdbc:TYPE_DATETIME, value: "2017-01-30T13:27:01.999999" };
    jdbc:Parameter dateTime2Val = { sqlType: jdbc:TYPE_DATETIME, value: "2017-01-30T13:27:01.999999" };
    jdbc:Parameter smallDateTimeVal = { sqlType: jdbc:TYPE_DATETIME, value: "2017-01-30T13:27:01.999999" };
    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, value: "13:27:01.999999" };

    var ret = testDB->call("{CALL CALL_TEST_IN_DATETIME_VALUES(?, ?, ?, ?, ?, ?, ?)}", (), id, dateVal,
                            dateTimeOffsetVal, dateTimeVal, dateTime2Val, smallDateTimeVal, timeVal);

    if (ret is error?) {
        return ret;
    } else {
        error e = error("Unexpected return type: table");
        return e;
    }
}

function testCallInParamComplexTypes() returns @tainted error? {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    jdbc:Parameter varBinaryVal = { sqlType: jdbc:TYPE_VARBINARY, value: "dmFyYmluYXJ5IENvbHVtbg==" };
    jdbc:Parameter imageVal = { sqlType: jdbc:TYPE_VARBINARY, value: "QmxvYiBDb2x1bW4gMg==" };

    var ret = testDB->call("{CALL CALL_TEST_IN_COMPLEX_TYPES(?, ?, ?, ?)}", (), id, binaryVal,
        varBinaryVal, imageVal);

    if (ret is error?) {
        return ret;
    } else {
        error e = error("Unexpected return type: table");
        return e;
    }
}

function testCallOutParamComplexTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter varBinaryVal = { sqlType: jdbc:TYPE_VARBINARY, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter imageVal = { sqlType: jdbc:TYPE_VARBINARY, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_COMPLEX_TYPES(? ,? ,?, ?)}", (), id, binaryVal, varBinaryVal, imageVal);
    any[] outParamValues = [ binaryVal.value, varBinaryVal.value, imageVal.value ];
    return [ret, outParamValues];
}

function testCallInOutParamComplexTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==",
                                  direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter varBinaryVal = { sqlType: jdbc:TYPE_VARBINARY, value: "dmFyYmluYXJ5IENvbHVtbg==",
                                    direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter imageVal = { sqlType: jdbc:TYPE_VARBINARY, value: "QmxvYiBDb2x1bW4gMg==",
                                direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_COMPLEX_TYPES(? ,? ,?, ?)}", (), id, binaryVal, varBinaryVal,
                            imageVal);
    any[] outParamValues = [ binaryVal.value, varBinaryVal.value, imageVal.value ];
    return [ret, outParamValues];
}

function setUpDatetimeData(int date, int time, int datetime, int timestamp) {
    string stmt =
    "INSERT INTO SELECT_UPDATE_TEST_DATETIME_TYPES values (?,?,?,?,?,?,?)";

    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: date };
    jdbc:Parameter dateTimeOffsetVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: timestamp };
    jdbc:Parameter dateTimeVal = { sqlType: jdbc:TYPE_DATETIME, value: datetime };
    jdbc:Parameter dateTime2Val = { sqlType: jdbc:TYPE_DATETIME, value: datetime };
    jdbc:Parameter smallDateTimeVal = { sqlType: jdbc:TYPE_DATETIME, value: datetime };
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

function testCallFunctionWithRefcursor() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CURSOR_TEST(?, ?, ?, ?, ?)}", (), id, charVal,
        varcharVal, ncharVal, nvarcharVal);
    any[] outparamValues = [ charVal.value, varcharVal.value, ncharVal.value, nvarcharVal.value ];
    return [ret, outparamValues];
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}
