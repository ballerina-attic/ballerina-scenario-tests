import ballerina/config;
import ballerina/time;
import ballerinax/java.jdbc;

jdbc:Client testDB = new({
        url: config:getAsString("database.postgresql.test.jdbc.url"),
        username: config:getAsString("database.postgresql.test.jdbc.username"),
        password: config:getAsString("database.postgresql.test.jdbc.password")
    });

function testCallOutParamIntegerTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, direction: jdbc:DIRECTION_OUT  };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, direction: jdbc:DIRECTION_OUT  };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, direction: jdbc:DIRECTION_OUT  };

    var ret = testDB->call("{CALL CALL_TEST_OUT_INTEGER_TYPES(?, ?, ?, ?)}", (), id, smallIntVal,
        intVal, bigIntVal);
    any[] outparamValues = [ smallIntVal.value, intVal.value, bigIntVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamIntegerTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id_in = { sqlType: jdbc:TYPE_INTEGER, value: 2, direction: jdbc:DIRECTION_IN };
    jdbc:Parameter id_out = { sqlType: jdbc:TYPE_INTEGER, value: 1, direction: jdbc:DIRECTION_IN };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32745, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 8388903, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 2147383644, direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_INTEGER_TYPES(?, ?, ?, ?, ?)}", (), id_in, id_out,
    smallIntVal, intVal, bigIntVal);
    any[] outparamValues = [smallIntVal.value, intVal.value, bigIntVal.value ];
    return [ret, outparamValues];
}

function testCallOutParamFixedPointTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_FIXED_POINT_TYPES(?, ?, ?)}", (), id, decimalVal,
        numericVal);
    any[] outparamValues = [ decimalVal.value, numericVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamFixedPointTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id_in = { sqlType: jdbc:TYPE_INTEGER, value: 2, direction: jdbc:DIRECTION_IN };
    jdbc:Parameter id_out = { sqlType: jdbc:TYPE_INTEGER, value: 1, direction: jdbc:DIRECTION_IN };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 123.78, direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1054.769, direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_FIXED_POINT_TYPES(?, ?, ?, ?)}", (), id_in, id_out,
    decimalVal, numericVal);
    any[] outparamValues = [ decimalVal.value, numericVal.value ];
    return [ret, outparamValues];
}

function testCallOutParamStringTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_VARCHAR, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_STRING_TYPES(?, ?, ?)}", (), id, varcharVal, textVal);
    any[] outparamValues = [ varcharVal.value, textVal.value ];
    return [ret, outparamValues];
}

function testCallInOutParamStringTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id_in = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter id_out = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column 2", direction: jdbc:DIRECTION_INOUT };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Text column 2", direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_STRING_TYPES(?, ?, ?, ?)}", (), id_in, id_out, varcharVal, textVal);
    any[] outparamValues = [ varcharVal.value, textVal.value ];
    return [ret, outparamValues];
}

function testCallOutParamDateTimeValues() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter timezVal = { sqlType: jdbc:TYPE_TIME, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter timestampVal = { sqlType: jdbc:TYPE_DATETIME, direction: jdbc:DIRECTION_OUT };
    jdbc:Parameter timestampzVal = { sqlType: jdbc:TYPE_TIMESTAMP, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_DATETIME_TYPES(?, ?, ?, ?, ?, ?)}", (), id, dateVal, timeVal, timezVal,
    timestampVal, timestampzVal);
    any[] ourParamValues = [ dateVal.value, timeVal.value, timezVal.value, timestampVal.value, timestampzVal.value ];
    return [ret, ourParamValues];
}

function testCallInOutParamDateTimeValues() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id_in = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter id_out = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-03-27-08:01" };
    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999" };
    jdbc:Parameter timezVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999+08:33" };
    jdbc:Parameter timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };
    jdbc:Parameter timestampzVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_DATETIME_TYPES(?, ?, ?, ?, ?, ?, ?)}", (), id_in, id_out, dateVal,
    timeVal, timezVal, timestampVal, timestampzVal);
    any[] ourParamValues = [ dateVal.value, timeVal.value, timezVal.value, timestampVal.value, timestampzVal.value ];
    return [ret, ourParamValues];
}

function testCallOutParamComplexTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, direction: jdbc:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_COMPLEX_TYPES(? ,? )}", (), id, binaryVal);
    any[] outParamValues = [ binaryVal.value ];
    return [ret, outParamValues];
}

function testCallInOutParamComplexTypes() returns @tainted [table<record{}>[]|error?, any[]] {
    jdbc:Parameter id_in = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    jdbc:Parameter id_out = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbiAy", direction: jdbc:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_COMPLEX_TYPES(? ,? ,?)}", (), id_in, id_out, binaryVal);
    any[] outParamValues = [ binaryVal.value ];
    return [ret, outParamValues];
}

function setupDatetimeData() returns [int, int, int, int, int] {
    int dateInserted = -1;
    int timeInserted = -1;
    int timezInserted = -1;
    int timestampInserted = -1;
    int timestampzInserted = -1;
    time:Time dateRecord = checkpanic time:createTime(2017, 5, 23, 0, 0, 0, 0, "");

    time:TimeZone currentZone = dateRecord.zone;

    time:Time timezRecord = { time: 51323000, zone: currentZone };

    time:Time timestampzRecord = checkpanic time:createTime(2017, 1, 25, 16, 12, 23, 0, "");
    dateInserted = dateRecord.time;
    timeInserted = timezRecord.time;
    timezInserted = timezRecord.time;
    timestampInserted = timestampzRecord.time;
    timestampzInserted = timestampzRecord.time;

    jdbc:Parameter para0 = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter para1 = { sqlType: jdbc:TYPE_DATE, value: dateRecord };
    jdbc:Parameter para2 = { sqlType: jdbc:TYPE_TIME, value: timezRecord };
    jdbc:Parameter para3 = { sqlType: jdbc:TYPE_TIME, value: timezRecord };
    jdbc:Parameter para4 = { sqlType: jdbc:TYPE_TIMESTAMP, value: timestampzRecord };
    jdbc:Parameter para5 = { sqlType: jdbc:TYPE_TIMESTAMP, value: timestampzRecord };

    _ = checkpanic testDB->update("Insert into SELECT_UPDATE_TEST_DATETIME_TYPES values (?,?,?,?,?,?)",
        para0, para1, para2, para3, para4, para5);
    return [dateInserted, timeInserted, timezInserted, timestampInserted, timestampzInserted];
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}

