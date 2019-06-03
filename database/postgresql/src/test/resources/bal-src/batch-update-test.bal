import ballerina/sql;
import ballerina/config;
import ballerinax/jdbc;

jdbc:Client testDB =  new jdbc:Client({
        url: config:getAsString("database.postgresql.test.jdbc.url"),
        username: config:getAsString("database.postgresql.test.jdbc.username"),
        password: config:getAsString("database.postgresql.test.jdbc.password")
    });

function testBatchUpdateIntegerTypesWithParams() returns int[] | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter smallIntVal = { sqlType: sql:TYPE_SMALLINT, value: 32765 };
    sql:Parameter intVal = { sqlType: sql:TYPE_INTEGER, value: 8388603 };
    sql:Parameter bigIntVal = { sqlType: sql:TYPE_BIGINT, value: 2147483644 };

    sql:Parameter?[] paramBatch1 = [id, smallIntVal, intVal, bigIntVal];

    id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    smallIntVal = { sqlType: sql:TYPE_SMALLINT, value: 32765 };
    intVal = { sqlType: sql:TYPE_INTEGER, value: 8389603 };
    bigIntVal = { sqlType: sql:TYPE_BIGINT, value: 2147489144 };

    sql:Parameter?[] paramBatch2 = [id, smallIntVal, intVal, bigIntVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_INTEGER_TYPES", 4, paramBatch1, paramBatch2);
}

function testBatchUpdateFixedPointTypesWithParams() returns int[] | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter decimalVal = { sqlType: sql:TYPE_DECIMAL, value: 143.78 };
    sql:Parameter numericVal = { sqlType: sql:TYPE_NUMERIC, value: 1034.789 };

    sql:Parameter?[] paramBatch1 = [id, decimalVal, numericVal];

    id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    decimalVal = { sqlType: sql:TYPE_DECIMAL, value: 243.58 };
    numericVal = { sqlType: sql:TYPE_NUMERIC, value: 1134.769 };

    sql:Parameter?[] paramBatch2 = [id, decimalVal, numericVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", 3, paramBatch1, paramBatch2);
}

function testBatchUpdateStringTypesWithParams() returns int[] | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter varcharVal = { sqlType: sql:TYPE_VARCHAR, value: "Varchar column" };
    sql:Parameter textVal = { sqlType: sql:TYPE_LONGNVARCHAR, value: "Text column" };

    sql:Parameter?[] paramBatch1 = [id, varcharVal, textVal];

    id = { sqlType: sql:TYPE_INTEGER, value: 2 };
    varcharVal = { sqlType: sql:TYPE_VARCHAR, value: "Varchar column" };
    textVal = { sqlType: sql:TYPE_LONGNVARCHAR, value: "Text column" };

    sql:Parameter?[] paramBatch2 = [id, varcharVal, textVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_STRING_TYPES", 3, paramBatch1, paramBatch2);
}

function testBatchUpdateComplexTypesWithParams() returns int[] | error {
    sql:Parameter id =  { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter binaryVal =  { sqlType: sql:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };

    sql:Parameter?[] paramBatch1 = [id, binaryVal];

    id =  { sqlType: sql:TYPE_INTEGER, value: 2 };
    binaryVal =  { sqlType: sql:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };

    sql:Parameter?[] paramBatch2 = [id, binaryVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_COMPLEX_TYPES", 2, paramBatch1, paramBatch2);
}

function testBatchUpdateDateTimeWithValuesParam() returns int[] | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter dateVal = { sqlType: sql:TYPE_DATE, value: "2019-03-27-08:01" };
    sql:Parameter timeVal = { sqlType: sql:TYPE_TIME, value: "17:43:21.999999" };
    sql:Parameter timezVal = { sqlType: sql:TYPE_TIME, value: "17:43:21.999999+08:33" };
    sql:Parameter timestampVal = { sqlType: sql:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };
    sql:Parameter timestampzVal = { sqlType: sql:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };

    sql:Parameter?[] paramBatch1 = [id, dateVal, timeVal, timezVal, timestampVal, timestampzVal];

    id = { sqlType: sql:TYPE_INTEGER, value: 2 };
    dateVal = { sqlType: sql:TYPE_DATE, value: "2019-03-27-08:01" };
    timeVal = { sqlType: sql:TYPE_TIME, value: "17:43:21.999999" };
    timezVal = { sqlType: sql:TYPE_TIME, value: "17:43:21.999999+08:33" };
    timestampVal = { sqlType: sql:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };
    timestampzVal = { sqlType: sql:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };

    sql:Parameter?[] paramBatch2 = [id, dateVal, timeVal, timezVal, timestampVal, timestampzVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_DATETIME_TYPES", 6, paramBatch1, paramBatch2);
}


function runInsertQueryWithParams(string tableName, int paramCount, sql:Parameter?[]... parameters)
             returns int[] | error {
    string paramString = "";
    if (paramCount >= 1) {
        paramString += "?";
    }
    if (paramCount > 1) {
        int i = 1;
        while (i < paramCount) {
            paramString += ", ?";
            i = i + 1;
        }
    }
    return testDB->batchUpdate("INSERT INTO " + tableName + " VALUES(" + paramString + ")", ...parameters);
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}


