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
      url: config:getAsString("database.mysql.test.jdbc.url"),
      username: config:getAsString("database.mysql.test.jdbc.username"),
      password: config:getAsString("database.mysql.test.jdbc.password")
});
//
//function testCallInParamNumericTypes() returns error? {
//    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
//    jdbc:Parameter bitVal = { sqlType: jdbc:TYPE_BIT, value: 1 };
//    jdbc:Parameter tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, value: 126 };
//    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32765 };
//    jdbc:Parameter mediumIntVal = { sqlType: jdbc:TYPE_INTEGER, value: 32765 };
//    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 8388603 };
//    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 2147483644 };
//    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 143.78 };
//    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1034.789 };
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

function testCallOutParamNumericTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter bitVal = { sqlType: jdbc:TYPE_BIT, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, direction: jdbc:DIRECTION_OUT  };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, direction: jdbc:DIRECTION_OUT  };
    jdbc:Parameter mediumIntVal = { sqlType: jdbc:TYPE_INTEGER, direction: jdbc:DIRECTION_OUT  };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, direction: jdbc:DIRECTION_OUT  };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, direction: jdbc:DIRECTION_OUT  };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, direction: jdbc:DIRECTION_OUT  };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, direction: jdbc:DIRECTION_OUT  };

    var ret = testDB->call("CALL CALL_TEST_OUT_NUMERIC_TYPES(?, ?, ?, ?, ?, ?, ?, ?, ?)", (), id, bitVal, tinyIntVal, smallIntVal, mediumIntVal,
        intVal, bigIntVal, decimalVal, numericVal);
    any[] outparamValues = [ bitVal.value, tinyIntVal.value, smallIntVal.value, mediumIntVal.value, intVal.value, bigIntVal.value, decimalVal.value, numericVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamNumericTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id_in = { sqlType: jdbc:TYPE_INTEGER, value: 2, direction: jdbc:DIRECTION_IN };
    jdbc:Parameter id_out = { sqlType: jdbc:TYPE_INTEGER, value: 1, direction: jdbc:DIRECTION_IN };
    jdbc:Parameter bitVal = { sqlType: jdbc:TYPE_BIT, value: 1, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, value: 124, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32745, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter mediumIntVal = { sqlType: jdbc:TYPE_INTEGER, value: 32745, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 8388903, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 2147383644, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 123.78, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1054.769, direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("CALL CALL_TEST_INOUT_NUMERIC_TYPES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (), id_in, id_out, bitVal, tinyIntVal, smallIntVal, mediumIntVal,
        intVal, bigIntVal, decimalVal, numericVal);
    any[] outparamValues = [ bitVal.value, tinyIntVal.value, smallIntVal.value, mediumIntVal.value, intVal.value, bigIntVal.value, decimalVal.value, numericVal.value ];
    return [ret, outparamValues];
}

function testCallOutParamStringTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_VARCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter tinyTextVal = { sqlType: jdbc:TYPE_VARCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_VARCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter mediumTextVal = { sqlType: jdbc:TYPE_CLOB, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter longTextVal = { sqlType: jdbc:TYPE_CLOB, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter setVal = { sqlType: jdbc:TYPE_VARCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter enumVal = { sqlType: jdbc:TYPE_VARCHAR, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("CALL CALL_TEST_OUT_STRING_TYPES(?, ?, ?, ?, ?, ?, ?, ?, ?)", (), id, charVal, varcharVal, tinyTextVal, textVal, mediumTextVal, longTextVal, setVal, enumVal);
    any[] outparamValues = [ charVal.value, varcharVal.value, tinyTextVal.value, textVal.value, mediumTextVal.value, longTextVal.value, setVal.value, enumVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamStringTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id_in = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter id_out = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Char Column 2", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column 2", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter tinyTextVal = { sqlType: jdbc:TYPE_VARCHAR, value: "TinyText column 2", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Text column 2", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter mediumTextVal = { sqlType: jdbc:TYPE_CLOB, value: "MediumText column 2", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter longTextVal = { sqlType: jdbc:TYPE_CLOB, value: "LongText column 2", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter setVal = { sqlType: jdbc:TYPE_VARCHAR, value: "B", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter enumVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Y", direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("CALL CALL_TEST_INOUT_STRING_TYPES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", (), id_in, id_out, charVal, varcharVal, tinyTextVal, textVal, mediumTextVal, longTextVal, setVal, enumVal);
    any[] outparamValues = [ charVal.value, varcharVal.value, tinyTextVal.value, textVal.value, mediumTextVal.value, longTextVal.value, setVal.value, enumVal.value ];
    return [ret, outparamValues];
}

function testCallOutParamDateTimeValues() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter datetimeVal = { sqlType: jdbc:TYPE_DATETIME, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, direction: jdbc:DIRECTION_OUT };
    //jdbc:Parameter yearVal = { sqlType: jdbc:TYPE_DATE, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("CALL CALL_TEST_OUT_DATETIME_TYPES(?, ?, ?, ?, ?)", (), id, dateVal, timeVal, datetimeVal, timestampVal);
    any[] ourParamValues = [ dateVal.value, timeVal.value, datetimeVal.value, timestampVal.value ];
    return [ret, ourParamValues];
}

function testCallInOutParamDateTimeValues() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id_out = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter id_in = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-04-27-08:01", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, value: "16:43:21.999999+08:33", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter dateTimeVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1948-03-04T01:05:15.999-08:00", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1970-01-01T01:05:15.999-08:00", direction: jdbc:DIRECTION_INOUT };
    //jdbc:Parameter yearVal = { sqlType: jdbc:TYPE_INTEGER, value: "1991" };

    var ret = testDB->call("CALL CALL_TEST_INOUT_DATETIME_TYPES(?, ?, ?, ?, ?, ?)", (), id_in, id_out, dateVal, timeVal, dateTimeVal, timestampVal);
    any[] ourParamValues = [ dateVal.value, timeVal.value, dateTimeVal.value, timestampVal.value ];
    return [ret, ourParamValues];
}

function testCallOutParamComplexTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter varBinaryVal = { sqlType: jdbc:TYPE_BINARY, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter tinyBlobVal = { sqlType: jdbc:TYPE_BLOB, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter blobVal = { sqlType: jdbc:TYPE_BLOB, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter mediumBlobVal = { sqlType: jdbc:TYPE_BLOB, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter longBlobVal = { sqlType: jdbc:TYPE_BLOB, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("CALL CALL_TEST_OUT_COMPLEX_TYPES(? ,? ,?, ?, ?, ?, ?)", (), id, binaryVal, varBinaryVal, tinyBlobVal, blobVal, mediumBlobVal, longBlobVal);
    any[] outParamValues = [ binaryVal.value, varBinaryVal.value, tinyBlobVal.value, blobVal.value, mediumBlobVal.value, longBlobVal.value ];
    return [ret, outParamValues];
}

function testCallInOutParamComplexTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id_in = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter id_out = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbiAy", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter varBinaryVal = { sqlType: jdbc:TYPE_BINARY, value: "VmFyYmluYXJ5IENvbHVtbiAy", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter tinyBlobVal = { sqlType: jdbc:TYPE_BLOB, value: "VGlueUJsb2IgQ29sdW1uIDI=", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter blobVal = { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4gMg==", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter mediumBlobVal = { sqlType: jdbc:TYPE_BLOB, value: "TWVkaXVtQmxvYiBDb2x1bW4gMg==", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter longBlobVal = { sqlType: jdbc:TYPE_BLOB, value: "TG9uZ0Jsb2IgQ29sdW1uIDI=", direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("CALL CALL_TEST_INOUT_COMPLEX_TYPES(? ,? ,?, ?, ?, ?, ?, ?)", (), id_in, id_out, binaryVal, varBinaryVal, tinyBlobVal, blobVal, mediumBlobVal, longBlobVal);
    any[] outParamValues = [ binaryVal.value, varBinaryVal.value, tinyBlobVal.value, blobVal.value, mediumBlobVal.value, longBlobVal.value ];
    return [ret, outParamValues];
}

function setUpDatetimeData(int date, int time, int datetime, int timestamp) {
    string stmt =
    "INSERT INTO SELECT_UPDATE_TEST_DATETIME_TYPES values (?,?,?,?,?,?)";
    int[] returnValues = [];

    jdbc:Parameter para1 = { sqlType: jdbc:TYPE_DATE, value: date };
    jdbc:Parameter para2 = { sqlType: jdbc:TYPE_TIME, value: time };
    jdbc:Parameter para3 = { sqlType: jdbc:TYPE_TIMESTAMP, value: datetime };
    jdbc:Parameter para4 = { sqlType: jdbc:TYPE_TIMESTAMP, value: timestamp };

    var insertRet = testDB->update(stmt, 1, para1, para2, para3, para4, 2019);
    if (insertRet is error) {
        error err = insertRet;
        anydata|error detailContent = err.detail()["message"];
        string errorMessage = detailContent is string ? detailContent : "Error trace continues";
        error e = error("Setting up date time data failed: " + errorMessage);
        panic e;
    }
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}
