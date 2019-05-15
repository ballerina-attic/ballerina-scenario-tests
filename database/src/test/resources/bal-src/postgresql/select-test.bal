import ballerina/config;
import ballerina/io;
import ballerina/sql;
import ballerina/time;
import ballerinax/jdbc;

type IntegerType record {
    int id;
    int? smallIntVal;
    int? intVal;
    int? bigIntVal;
};

type FixedPointType record {
    int id;
    decimal? numericVal;
    decimal? decimalVal;
};

type FloatingPointType record {
    int id;
    float? realVal;
    float? doubleVal;
};

type StringType record {
    int id;
    string? varcharVal;
    string? textVal;
};

type DateTimeTypeStr record {
    string? dateStr;
    string? timeStr;
    string? timezStr;
    string? timestampStr;
    string? timestampzStr;
};

type DateTimeTypeInt record {
    int? dateInt;
    int? timeInt;
    int? timezInt;
    int? timestampInt;
    int? timestampzInt;
};

type DateTimeTypeRec record {
    time:Time? dateRec;
    time:Time? timeRec;
    time:Time? timezRec;
    time:Time? timestampRec;
    time:Time? timestampzRec;
};

type ComplexType record {
    int id;
    byte[]|() binaryVal;
};

const string DATE_VAL = "DATE_VAL";
const string TIME_VAL = "TIME_VAL";
const string TIMEZ_VAL = "TIMEZ_VAL";
const string TIMESTAMP_VAL = "TIMESTAMP_VAL";
const string TIMESTAMPZ_VAL = "TIMESTAMPZ_VAL";

jdbc:Client testDB = new({
        url: config:getAsString("database.postgres.test.jdbc.url"),
        username: config:getAsString("database.postgres.test.jdbc.username"),
        password: config:getAsString("database.postgres.test.jdbc.password")
    });

function testSelectIntegerTypes() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_INTEGER_TYPES", 1, IntegerType);
}

function testSelectIntegerTypesNil() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_INTEGER_TYPES", 2, IntegerType);
}

function testSelectFixedPointTypes() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", 1, FixedPointType);
}

function testSelectFixedPointTypesNil() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", 2, FixedPointType);
}

function testSelectFloatTypes() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_FLOAT_TYPES", 1, FloatingPointType);
}

function testSelectFloatTypesNil() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_FLOAT_TYPES", 2, FloatingPointType);
}

function testSelectStringTypes() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_STRING_TYPES", 1, StringType);
}

function testSelectStringTypesNil() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_STRING_TYPES", 2, StringType);
}

function testDateTimeTypesString() returns record{} | error {
    return runSelectSetQuery("SELECT_UPDATE_TEST_DATETIME_TYPES", 1, DateTimeTypeStr, DATE_VAL, TIME_VAL, TIMEZ_VAL,
        TIMESTAMP_VAL, TIMESTAMPZ_VAL);
}

function testDateTimeTypesInt() returns record{} | error {
    return runSelectSetQuery("SELECT_UPDATE_TEST_DATETIME_TYPES", 1, DateTimeTypeInt, DATE_VAL, TIME_VAL, TIMEZ_VAL,
        TIMESTAMP_VAL, TIMESTAMPZ_VAL);
}

function testDateTimeTypesNil() returns record{} | error {
    return runSelectSetQuery("SELECT_UPDATE_TEST_DATETIME_TYPES", 2, DateTimeTypeInt, DATE_VAL, TIME_VAL, TIMEZ_VAL,
        TIMESTAMP_VAL, TIMESTAMPZ_VAL);
}

function testDateTimeTypesRecord() returns record{} | error {
    return runSelectSetQuery("SELECT_UPDATE_TEST_DATETIME_TYPES", 1, DateTimeTypeRec, DATE_VAL, TIME_VAL, TIMEZ_VAL,
        TIMESTAMP_VAL, TIMESTAMPZ_VAL);
}

function testComplexTypes() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_COMPLEX_TYPES", 1, ComplexType);
}

function testComplexTypesNil() returns record{} | error {
    return runSelectAllQuery("SELECT_UPDATE_TEST_COMPLEX_TYPES", 2, ComplexType);
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

function runSelectSetQuery(string tableName, int id, typedesc recordType, string... fields) returns record{} | error {
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

function runSelectAllQuery(string tableName, int id, typedesc recordType) returns record{} | error {
    return runSelectSetQuery(tableName, id, recordType, "*");
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}
