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
import ballerina/sql;
import ballerinax/jdbc;

jdbc:Client testDB = new({
      url: config:getAsString("database.mysql.test.jdbc.url"),
      username: config:getAsString("database.mysql.test.jdbc.username"),
      password: config:getAsString("database.mysql.test.jdbc.password")
});
//
//function testCallInParamNumericTypes() returns error? {
//    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 2 };
//    sql:Parameter bitVal = { sqlType: sql:TYPE_BIT, value: 1 };
//    sql:Parameter tinyIntVal = { sqlType: sql:TYPE_TINYINT, value: 126 };
//    sql:Parameter smallIntVal = { sqlType: sql:TYPE_SMALLINT, value: 32765 };
//    sql:Parameter mediumIntVal = { sqlType: sql:TYPE_INTEGER, value: 32765 };
//    sql:Parameter intVal = { sqlType: sql:TYPE_INTEGER, value: 8388603 };
//    sql:Parameter bigIntVal = { sqlType: sql:TYPE_BIGINT, value: 2147483644 };
//    sql:Parameter decimalVal = { sqlType: sql:TYPE_DECIMAL, value: 143.78 };
//    sql:Parameter numericVal = { sqlType: sql:TYPE_NUMERIC, value: 1034.789 };
//
//    var ret = testDB->call("CALL CALL_TEST_IN_NUMERIC_TYPES(?, ?, ?, ?, ?, ?, ?, ?, ?)", (), id, bitVal, tinyIntVal, smallIntVal, mediumIntVal,
//        intVal, bigIntVal, decimalVal, numericVal);
//    if (ret is error?) {
//        return ret;
//    } else {
//        error e = error("Unexpected return type: table");
//        return e;
//    }
//}

function testCallOutParamNumericTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter bitVal = { sqlType: sql:TYPE_BIT, direction: sql:DIRECTION_OUT };
    sql:Parameter tinyIntVal = { sqlType: sql:TYPE_TINYINT, direction: sql:DIRECTION_OUT  };
    sql:Parameter smallIntVal = { sqlType: sql:TYPE_SMALLINT, direction: sql:DIRECTION_OUT  };
    sql:Parameter mediumIntVal = { sqlType: sql:TYPE_INTEGER, direction: sql:DIRECTION_OUT  };
    sql:Parameter intVal = { sqlType: sql:TYPE_INTEGER, direction: sql:DIRECTION_OUT  };
    sql:Parameter bigIntVal = { sqlType: sql:TYPE_BIGINT, direction: sql:DIRECTION_OUT  };
    sql:Parameter decimalVal = { sqlType: sql:TYPE_DECIMAL, direction: sql:DIRECTION_OUT  };
    sql:Parameter numericVal = { sqlType: sql:TYPE_NUMERIC, direction: sql:DIRECTION_OUT  };

    var ret = testDB->call("CALL CALL_TEST_OUT_NUMERIC_TYPES(?, ?, ?, ?, ?, ?, ?, ?, ?)", (), id, bitVal, tinyIntVal, smallIntVal, mediumIntVal,
        intVal, bigIntVal, decimalVal, numericVal);
    any[] outparamValues = [ bitVal.value, tinyIntVal.value, smallIntVal.value, mediumIntVal.value, intVal.value, bigIntVal.value, decimalVal.value, numericVal.value ];
    return (ret, outparamValues);
}

function testCallInOutParamNumericTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id_in = { sqlType: sql:TYPE_INTEGER, value: 2, direction: sql:DIRECTION_IN };
    sql:Parameter id_out = { sqlType: sql:TYPE_INTEGER, value: 1, direction: sql:DIRECTION_IN };
    sql:Parameter bitVal = { sqlType: sql:TYPE_BIT, value: 1, direction: sql:DIRECTION_INOUT };
    sql:Parameter tinyIntVal = { sqlType: sql:TYPE_TINYINT, value: 124, direction: sql:DIRECTION_INOUT };
    sql:Parameter smallIntVal = { sqlType: sql:TYPE_SMALLINT, value: 32745, direction: sql:DIRECTION_INOUT };
    sql:Parameter mediumIntVal = { sqlType: sql:TYPE_INTEGER, value: 32745, direction: sql:DIRECTION_INOUT };
    sql:Parameter intVal = { sqlType: sql:TYPE_INTEGER, value: 8388903, direction: sql:DIRECTION_INOUT };
    sql:Parameter bigIntVal = { sqlType: sql:TYPE_BIGINT, value: 2147383644, direction: sql:DIRECTION_INOUT };
    sql:Parameter decimalVal = { sqlType: sql:TYPE_DECIMAL, value: 123.78, direction: sql:DIRECTION_INOUT };
    sql:Parameter numericVal = { sqlType: sql:TYPE_NUMERIC, value: 1054.769, direction: sql:DIRECTION_INOUT };

    var ret = testDB->call("CALL CALL_TEST_INOUT_NUMERIC_TYPES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (), id_in, id_out, bitVal, tinyIntVal, smallIntVal, mediumIntVal,
        intVal, bigIntVal, decimalVal, numericVal);
    any[] outparamValues = [ bitVal.value, tinyIntVal.value, smallIntVal.value, mediumIntVal.value, intVal.value, bigIntVal.value, decimalVal.value, numericVal.value ];
    return (ret, outparamValues);
}

function testCallOutParamStringTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter charVal = { sqlType: sql:TYPE_VARCHAR, direction: sql:DIRECTION_OUT };
    sql:Parameter varcharVal = { sqlType: sql:TYPE_VARCHAR, direction: sql:DIRECTION_OUT };
    sql:Parameter tinyTextVal = { sqlType: sql:TYPE_VARCHAR, direction: sql:DIRECTION_OUT };
    sql:Parameter textVal = { sqlType: sql:TYPE_VARCHAR, direction: sql:DIRECTION_OUT };
    sql:Parameter mediumTextVal = { sqlType: sql:TYPE_CLOB, direction: sql:DIRECTION_OUT };
    sql:Parameter longTextVal = { sqlType: sql:TYPE_CLOB, direction: sql:DIRECTION_OUT };
    sql:Parameter setVal = { sqlType: sql:TYPE_VARCHAR, direction: sql:DIRECTION_OUT };
    sql:Parameter enumVal = { sqlType: sql:TYPE_VARCHAR, direction: sql:DIRECTION_OUT };

    var ret = testDB->call("CALL CALL_TEST_OUT_STRING_TYPES(?, ?, ?, ?, ?, ?, ?, ?, ?)", (), id, charVal, varcharVal, tinyTextVal, textVal, mediumTextVal, longTextVal, setVal, enumVal);
    any[] outparamValues = [ charVal.value, varcharVal.value, tinyTextVal.value, textVal.value, mediumTextVal.value, longTextVal.value, setVal.value, enumVal.value ];
    return (ret, outparamValues);
}

function testCallInOutParamStringTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id_in = { sqlType: sql:TYPE_INTEGER, value: 2 };
    sql:Parameter id_out = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter charVal = { sqlType: sql:TYPE_VARCHAR, value: "Char Column 2", direction: sql:DIRECTION_INOUT };
    sql:Parameter varcharVal = { sqlType: sql:TYPE_VARCHAR, value: "Varchar column 2", direction: sql:DIRECTION_INOUT };
    sql:Parameter tinyTextVal = { sqlType: sql:TYPE_VARCHAR, value: "TinyText column 2", direction: sql:DIRECTION_INOUT };
    sql:Parameter textVal = { sqlType: sql:TYPE_VARCHAR, value: "Text column 2", direction: sql:DIRECTION_INOUT };
    sql:Parameter mediumTextVal = { sqlType: sql:TYPE_CLOB, value: "MediumText column 2", direction: sql:DIRECTION_INOUT };
    sql:Parameter longTextVal = { sqlType: sql:TYPE_CLOB, value: "LongText column 2", direction: sql:DIRECTION_INOUT };
    sql:Parameter setVal = { sqlType: sql:TYPE_VARCHAR, value: "B", direction: sql:DIRECTION_INOUT };
    sql:Parameter enumVal = { sqlType: sql:TYPE_VARCHAR, value: "Y", direction: sql:DIRECTION_INOUT };

    var ret = testDB->call("CALL CALL_TEST_INOUT_STRING_TYPES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (), id_in, id_out, charVal, varcharVal, tinyTextVal, textVal, mediumTextVal, longTextVal, setVal, enumVal);
    any[] outparamValues = [ charVal.value, varcharVal.value, tinyTextVal.value, textVal.value, mediumTextVal.value, longTextVal.value, setVal.value, enumVal.value ];
    return (ret, outparamValues);
}

function testCallOutParamDateTimeValues() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter dateVal = { sqlType: sql:TYPE_DATE, direction: sql:DIRECTION_OUT };
    sql:Parameter timeVal = { sqlType: sql:TYPE_TIME, direction: sql:DIRECTION_OUT };
    sql:Parameter datetimeVal = { sqlType: sql:TYPE_DATETIME, direction: sql:DIRECTION_OUT };
    sql:Parameter timestampVal = { sqlType: sql:TYPE_TIMESTAMP, direction: sql:DIRECTION_OUT };
    //sql:Parameter yearVal = { sqlType: sql:TYPE_DATE, direction: sql:DIRECTION_OUT };

    var ret = testDB->call("CALL CALL_TEST_OUT_DATETIME_TYPES(?, ?, ?, ?, ?)", (), id, dateVal, timeVal, datetimeVal, timestampVal);
    any[] ourParamValues = [ dateVal.value, timeVal.value, datetimeVal.value, timestampVal.value ];
    return (ret, ourParamValues);
}

function testCallInOutParamDateTimeValues() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id_out = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter id_in = { sqlType: sql:TYPE_INTEGER, value: 2 };
    sql:Parameter dateVal = { sqlType: sql:TYPE_DATE, value: "2019-04-27-08:01", direction: sql:DIRECTION_INOUT };
    sql:Parameter timeVal = { sqlType: sql:TYPE_TIME, value: "16:43:21.999999+08:33", direction: sql:DIRECTION_INOUT };
    sql:Parameter dateTimeVal = { sqlType: sql:TYPE_TIMESTAMP, value: "1948-03-04T01:05:15.999-08:00", direction: sql:DIRECTION_INOUT };
    sql:Parameter timestampVal = { sqlType: sql:TYPE_TIMESTAMP, value: "1970-01-01T01:05:15.999-08:00", direction: sql:DIRECTION_INOUT };
    //sql:Parameter yearVal = { sqlType: sql:TYPE_INTEGER, value: "1991" };

    var ret = testDB->call("CALL CALL_TEST_INOUT_DATETIME_TYPES(?, ?, ?, ?, ?, ?)", (), id_in, id_out, dateVal, timeVal, dateTimeVal, timestampVal);
    any[] ourParamValues = [ dateVal.value, timeVal.value, dateTimeVal.value, timestampVal.value ];
    return (ret, ourParamValues);
}

function testCallOutParamComplexTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter binaryVal =  { sqlType: sql:TYPE_BINARY, direction: sql:DIRECTION_OUT };
    sql:Parameter varBinaryVal = { sqlType: sql:TYPE_BINARY, direction: sql:DIRECTION_OUT };
    sql:Parameter tinyBlobVal = { sqlType: sql:TYPE_BLOB, direction: sql:DIRECTION_OUT };
    sql:Parameter blobVal = { sqlType: sql:TYPE_BLOB, direction: sql:DIRECTION_OUT };
    sql:Parameter mediumBlobVal = { sqlType: sql:TYPE_BLOB, direction: sql:DIRECTION_OUT };
    sql:Parameter longBlobVal = { sqlType: sql:TYPE_BLOB, direction: sql:DIRECTION_OUT };

    var ret = testDB->call("CALL CALL_TEST_OUT_COMPLEX_TYPES(? ,? ,?, ?, ?, ?, ?)", (), id, binaryVal, varBinaryVal, tinyBlobVal, blobVal, mediumBlobVal, longBlobVal);
    any[] outParamValues = [ binaryVal.value, varBinaryVal.value, tinyBlobVal.value, blobVal.value, mediumBlobVal.value, longBlobVal.value ];
    return (ret, outParamValues);
}

function testCallInOutParamComplexTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id_in = { sqlType: sql:TYPE_INTEGER, value: 2 };
    sql:Parameter id_out = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter binaryVal =  { sqlType: sql:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbiAy", direction: sql:DIRECTION_INOUT };
    sql:Parameter varBinaryVal = { sqlType: sql:TYPE_BINARY, value: "VmFyYmluYXJ5IENvbHVtbiAy", direction: sql:DIRECTION_INOUT };
    sql:Parameter tinyBlobVal = { sqlType: sql:TYPE_BLOB, value: "VGlueUJsb2IgQ29sdW1uIDI=", direction: sql:DIRECTION_INOUT };
    sql:Parameter blobVal = { sqlType: sql:TYPE_BLOB, value: "QmxvYiBDb2x1bW4gMg==", direction: sql:DIRECTION_INOUT };
    sql:Parameter mediumBlobVal = { sqlType: sql:TYPE_BLOB, value: "TWVkaXVtQmxvYiBDb2x1bW4gMg==", direction: sql:DIRECTION_INOUT };
    sql:Parameter longBlobVal = { sqlType: sql:TYPE_BLOB, value: "TG9uZ0Jsb2IgQ29sdW1uIDI=", direction: sql:DIRECTION_INOUT };

    var ret = testDB->call("CALL CALL_TEST_INOUT_COMPLEX_TYPES(? ,? ,?, ?, ?, ?, ?, ?)", (), id_in, id_out, binaryVal, varBinaryVal, tinyBlobVal, blobVal, mediumBlobVal, longBlobVal);
    any[] outParamValues = [ binaryVal.value, varBinaryVal.value, tinyBlobVal.value, blobVal.value, mediumBlobVal.value, longBlobVal.value ];
    return (ret, outParamValues);
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

function stopDatabaseClient() {
    checkpanic testDB.stop();
}
