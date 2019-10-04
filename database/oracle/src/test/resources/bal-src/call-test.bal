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
    url: config:getAsString("database.oracle.test.jdbc.url"),
    username: config:getAsString("database.oracle.test.jdbc.username"),
    password: config:getAsString("database.oracle.test.jdbc.password")
});

function testCallInParamIntegerTypes() returns @tainted error? {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 922337203 };

    var ret = testDB->call("{CALL CALL_TEST_IN_INTEGER_TYPES(?, ?)}", (), id, intVal);

    if (ret is error?) {
        return ret;
    } else {
        error e = error("Unexpected return type: table");
        return e;
    }
}

function testCallOutParamIntegerTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_INTEGER_TYPES(?, ?)}", (), id, intVal);
    any[] outparamValues = [ intVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamIntegerTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2, direction: jdbc:DIRECTION_IN };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 922337203, direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_INTEGER_TYPES(?, ?)}", (), id, intVal);
    any[] outparamValues = [ intVal.value ];
    return [ret, outparamValues];
}

function testCallInParamFixedPointTypes() returns @tainted error? {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 999.125698 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 10912.3412378 };

    var ret = testDB->call("{CALL CALL_IN_FIXEDPOINT_TYPES(?, ?, ?)}", (), id, numericVal, decimalVal);
    if (ret is error?) {
        return ret;
    } else {
        error e = error("Unexpected return type: table");
        return e;
    }
}

function testCallOutParamFixedPointTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_OUT_FIXEDPOINT_TYPES(?, ?, ?)}", (), id, numericVal, decimalVal);
    any[] outparamValues = [ numericVal.value, decimalVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamFixedPointTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 999.125698, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 10912.3412378, direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_INOUT_FIXEDPOINT_TYPES(?, ?, ?)}", (), id, numericVal, decimalVal);
    any[] outparamValues = [ numericVal.value, decimalVal.value ];
    return [ret, outparamValues];
}

function testCallInParamFloatTypes() returns @tainted error? {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter floatVal = { sqlType: jdbc:TYPE_FLOAT, value: 123.33999633789062 };
    jdbc:Parameter doubleVal = { sqlType: jdbc:TYPE_DOUBLE, value: 109999.123412378914545 };

    var ret = testDB->call("{CALL CALL_IN_FLOAT_TYPES(?, ?, ?)}", (), id, floatVal, doubleVal);

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
    jdbc:Parameter doubleVal = { sqlType: jdbc:TYPE_DOUBLE, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_OUT_FLOAT_TYPES(?, ?, ?)}", (), id, floatVal, doubleVal);
    any[] outparamValues = [ floatVal.value, doubleVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamFloatTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter floatVal = { sqlType: jdbc:TYPE_FLOAT, value: 123.33999633789062, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter doubleVal = { sqlType: jdbc:TYPE_DOUBLE, value: 109999.123412378914545,
                                 direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_INOUT_FLOAT_TYPES(?, ?, ?)}", (), id, floatVal, doubleVal);
    any[] outparamValues = [ floatVal.value, doubleVal.value ];
    return [ret, outparamValues];
}

function testCallInParamStringTypes() returns @tainted error? {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, value: "Char Column" };
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, value: "යූනිකෝඩ් දත්ත" };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column" };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, value: "යූනිකෝඩ් දත්ත" };

    var ret = testDB->call("{CALL CALL_IN_STRING_TYPES(?, ?, ?, ?, ?)}", (), id, charVal, ncharVal, varcharVal,
                                nvarcharVal);
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
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_OUT_STRING_TYPES(?, ?, ?, ?, ?)}", (), id, charVal, ncharVal, varcharVal,
                            nvarcharVal);
    any[] outparamValues = [ charVal.value, ncharVal.value, varcharVal.value, nvarcharVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamStringTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, value: "Char Column", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, value: "යූනිකෝඩ් දත්ත", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column",
                                    direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, value: "යූනිකෝඩ් දත්ත",
                                    direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_INOUT_STRING_TYPES(?, ?, ?, ?, ?)}", (), id, charVal, ncharVal, varcharVal,
                             nvarcharVal);
    any[] outparamValues = [ charVal.value, ncharVal.value, varcharVal.value, nvarcharVal.value ];
    return [ret, outparamValues];
}

function testCallInParamComplexTypes() returns @tainted error? {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter blobVal =  { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4=" };
    jdbc:Parameter clobVal = { sqlType: jdbc:TYPE_CLOB, value: "Clob Column" };
    jdbc:Parameter nclobVal = { sqlType: jdbc:TYPE_NCLOB, value: "යූනිකෝඩ් දත්ත" };

    var ret = testDB->call("{CALL CALL_IN_COMPLEX_TYPES(?, ?, ?, ?)}", (), id, blobVal, clobVal, nclobVal);

    if (ret is error?) {
        return ret;
    } else {
        error e = error("Unexpected return type: table");
        return e;
    }
}

function testCallOutParamComplexTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter blobVal =  { sqlType: jdbc:TYPE_BLOB, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter clobVal = { sqlType: jdbc:TYPE_CLOB, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter nclobVal = { sqlType: jdbc:TYPE_NCLOB, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_OUT_COMPLEX_TYPES(? ,? ,?, ?)}", (), id, blobVal, clobVal, nclobVal);
    any[] outParamValues = [ blobVal.value, clobVal.value, nclobVal.value ];
    return [ret, outParamValues];
}

function testCallInOutParamComplexTypes() returns @tainted [table<record{}>[]|error?, any[]] {
jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter blobVal =  { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4=", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter clobVal = { sqlType: jdbc:TYPE_CLOB, value: "Clob Column", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter nclobVal = { sqlType: jdbc:TYPE_NCLOB, value: "යූනිකෝඩ් දත්ත", direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_INOUT_COMPLEX_TYPES(? ,? ,?, ?)}", (), id, blobVal, clobVal, nclobVal);
    any[] outParamValues = [ blobVal.value, clobVal.value, nclobVal.value ];
    return [ret, outParamValues];
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}
