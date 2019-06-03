import ballerina/config;
import ballerina/sql;
import ballerina/time;
import ballerinax/jdbc;

jdbc:Client testDB = new({
        url: config:getAsString("database.postgresql.test.jdbc.url"),
        username: config:getAsString("database.postgresql.test.jdbc.username"),
        password: config:getAsString("database.postgresql.test.jdbc.password")
    });

function testCallOutParamIntegerTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter smallIntVal = { sqlType: sql:TYPE_SMALLINT, direction: sql:DIRECTION_OUT  };
    sql:Parameter intVal = { sqlType: sql:TYPE_INTEGER, direction: sql:DIRECTION_OUT  };
    sql:Parameter bigIntVal = { sqlType: sql:TYPE_BIGINT, direction: sql:DIRECTION_OUT  };

    var ret = testDB->call("{CALL CALL_TEST_OUT_INTEGER_TYPES(?, ?, ?, ?)}", (), id, smallIntVal,
        intVal, bigIntVal);
    any[] outparamValues = [ smallIntVal.value, intVal.value, bigIntVal.value ];
    return (ret, outparamValues);
}

function testCallInOutParamIntegerTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id_in = { sqlType: sql:TYPE_INTEGER, value: 2, direction: sql:DIRECTION_IN };
    sql:Parameter id_out = { sqlType: sql:TYPE_INTEGER, value: 1, direction: sql:DIRECTION_IN };
    sql:Parameter smallIntVal = { sqlType: sql:TYPE_SMALLINT, value: 32745, direction: sql:DIRECTION_INOUT };
    sql:Parameter intVal = { sqlType: sql:TYPE_INTEGER, value: 8388903, direction: sql:DIRECTION_INOUT };
    sql:Parameter bigIntVal = { sqlType: sql:TYPE_BIGINT, value: 2147383644, direction: sql:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_INTEGER_TYPES(?, ?, ?, ?, ?)}", (), id_in, id_out,
    smallIntVal, intVal, bigIntVal);
    any[] outparamValues = [smallIntVal.value, intVal.value, bigIntVal.value ];
    return (ret, outparamValues);
}

function testCallOutParamFixedPointTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter decimalVal = { sqlType: sql:TYPE_DECIMAL, direction: sql:DIRECTION_OUT };
    sql:Parameter numericVal = { sqlType: sql:TYPE_NUMERIC, direction: sql:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_FIXED_POINT_TYPES(?, ?, ?)}", (), id, decimalVal,
        numericVal);
    any[] outparamValues = [ decimalVal.value, numericVal.value ];
    return (ret, outparamValues);
}

function testCallInOutParamFixedPointTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id_in = { sqlType: sql:TYPE_INTEGER, value: 2, direction: sql:DIRECTION_IN };
    sql:Parameter id_out = { sqlType: sql:TYPE_INTEGER, value: 1, direction: sql:DIRECTION_IN };
    sql:Parameter decimalVal = { sqlType: sql:TYPE_DECIMAL, value: 123.78, direction: sql:DIRECTION_INOUT };
    sql:Parameter numericVal = { sqlType: sql:TYPE_NUMERIC, value: 1054.769, direction: sql:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_FIXED_POINT_TYPES(?, ?, ?, ?)}", (), id_in, id_out,
    decimalVal, numericVal);
    any[] outparamValues = [ decimalVal.value, numericVal.value ];
    return (ret, outparamValues);
}

function testCallOutParamStringTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter varcharVal = { sqlType: sql:TYPE_VARCHAR, direction: sql:DIRECTION_OUT };
    sql:Parameter textVal = { sqlType: sql:TYPE_VARCHAR, direction: sql:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_STRING_TYPES(?, ?, ?)}", (), id, varcharVal, textVal);
    any[] outparamValues = [ varcharVal.value, textVal.value ];
    return (ret, outparamValues);
}

function testCallInOutParamStringTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id_in = { sqlType: sql:TYPE_INTEGER, value: 2 };
    sql:Parameter id_out = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter varcharVal = { sqlType: sql:TYPE_VARCHAR, value: "Varchar column 2", direction: sql:DIRECTION_INOUT };
    sql:Parameter textVal = { sqlType: sql:TYPE_VARCHAR, value: "Text column 2", direction: sql:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_STRING_TYPES(?, ?, ?, ?)}", (), id_in, id_out, varcharVal, textVal);
    any[] outparamValues = [ varcharVal.value, textVal.value ];
    return (ret, outparamValues);
}

function testCallOutParamDateTimeValues() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter dateVal = { sqlType: sql:TYPE_DATE, direction: sql:DIRECTION_OUT };
    sql:Parameter timeVal = { sqlType: sql:TYPE_TIME, direction: sql:DIRECTION_OUT };
    sql:Parameter timezVal = { sqlType: sql:TYPE_TIME, direction: sql:DIRECTION_OUT };
    sql:Parameter timestampVal = { sqlType: sql:TYPE_DATETIME, direction: sql:DIRECTION_OUT };
    sql:Parameter timestampzVal = { sqlType: sql:TYPE_TIMESTAMP, direction: sql:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_DATETIME_TYPES(?, ?, ?, ?, ?, ?)}", (), id, dateVal, timeVal, timezVal,
    timestampVal, timestampzVal);
    any[] ourParamValues = [ dateVal.value, timeVal.value, timezVal.value, timestampVal.value, timestampzVal.value ];
    return (ret, ourParamValues);
}

function testCallInOutParamDateTimeValues() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id_in = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter id_out = { sqlType: sql:TYPE_INTEGER, value: 2 };
    sql:Parameter dateVal = { sqlType: sql:TYPE_DATE, value: "2019-03-27-08:01" };
    sql:Parameter timeVal = { sqlType: sql:TYPE_TIME, value: "17:43:21.999999" };
    sql:Parameter timezVal = { sqlType: sql:TYPE_TIME, value: "17:43:21.999999+08:33" };
    sql:Parameter timestampVal = { sqlType: sql:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };
    sql:Parameter timestampzVal = { sqlType: sql:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_DATETIME_TYPES(?, ?, ?, ?, ?, ?, ?)}", (), id_in, id_out, dateVal,
    timeVal, timezVal, timestampVal, timestampzVal);
    any[] ourParamValues = [ dateVal.value, timeVal.value, timezVal.value, timestampVal.value, timestampzVal.value ];
    return (ret, ourParamValues);
}

function testCallOutParamComplexTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter binaryVal =  { sqlType: sql:TYPE_BINARY, direction: sql:DIRECTION_OUT };

    var ret = testDB->call("{CALL CALL_TEST_OUT_COMPLEX_TYPES(? ,? )}", (), id, binaryVal);
    any[] outParamValues = [ binaryVal.value ];
    return (ret, outParamValues);
}

function testCallInOutParamComplexTypes() returns (table<record{}>[]|error?, any[]) {
    sql:Parameter id_in = { sqlType: sql:TYPE_INTEGER, value: 2 };
    sql:Parameter id_out = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter binaryVal =  { sqlType: sql:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbiAy", direction: sql:DIRECTION_INOUT };

    var ret = testDB->call("{CALL CALL_TEST_INOUT_COMPLEX_TYPES(? ,? ,?)}", (), id_in, id_out, binaryVal);
    any[] outParamValues = [ binaryVal.value ];
    return (ret, outParamValues);
}

function setupDatetimeData() returns (int, int, int, int, int) {
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

    sql:Parameter para0 = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter para1 = { sqlType: sql:TYPE_DATE, value: dateRecord };
    sql:Parameter para2 = { sqlType: sql:TYPE_TIME, value: timezRecord };
    sql:Parameter para3 = { sqlType: sql:TYPE_TIME, value: timezRecord };
    sql:Parameter para4 = { sqlType: sql:TYPE_TIMESTAMP, value: timestampzRecord };
    sql:Parameter para5 = { sqlType: sql:TYPE_TIMESTAMP, value: timestampzRecord };

    _ = checkpanic testDB->update("Insert into SELECT_UPDATE_TEST_DATETIME_TYPES values (?,?,?,?,?,?)",
        para0, para1, para2, para3, para4, para5);
    return (dateInserted, timeInserted, timezInserted, timestampInserted, timestampzInserted);
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}

