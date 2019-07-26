import ballerina/config;
import ballerinax/java.jdbc;

jdbc:Client testDB =  new jdbc:Client({
        url: config:getAsString("database.postgresql.test.jdbc.url"),
        username: config:getAsString("database.postgresql.test.jdbc.username"),
        password: config:getAsString("database.postgresql.test.jdbc.password")
    });

function testBatchUpdateIntegerTypesWithParams() returns int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32765 };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 8388603 };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 2147483644 };

    jdbc:Parameter?[] paramBatch1 = [id, smallIntVal, intVal, bigIntVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32765 };
    intVal = { sqlType: jdbc:TYPE_INTEGER, value: 8389603 };
    bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 2147489144 };

    jdbc:Parameter?[] paramBatch2 = [id, smallIntVal, intVal, bigIntVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_INTEGER_TYPES", 4, paramBatch1, paramBatch2);
}

function testBatchUpdateFixedPointTypesWithParams() returns int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 143.78 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1034.789 };

    jdbc:Parameter?[] paramBatch1 = [id, decimalVal, numericVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 243.58 };
    numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1134.769 };

    jdbc:Parameter?[] paramBatch2 = [id, decimalVal, numericVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", 3, paramBatch1, paramBatch2);
}

function testBatchUpdateStringTypesWithParams() returns int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column" };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_LONGVARCHAR, value: "Text column" };

    jdbc:Parameter?[] paramBatch1 = [id, varcharVal, textVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column" };
    textVal = { sqlType: jdbc:TYPE_LONGVARCHAR, value: "Text column" };

    jdbc:Parameter?[] paramBatch2 = [id, varcharVal, textVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_STRING_TYPES", 3, paramBatch1, paramBatch2);
}

function testBatchUpdateComplexTypesWithParams() returns int[] | error {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };

    jdbc:Parameter?[] paramBatch1 = [id, binaryVal];

    id =  { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };

    jdbc:Parameter?[] paramBatch2 = [id, binaryVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_COMPLEX_TYPES", 2, paramBatch1, paramBatch2);
}

function testBatchUpdateDateTimeWithValuesParam() returns int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-03-27-08:01" };
    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999" };
    jdbc:Parameter timezVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999+08:33" };
    jdbc:Parameter timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };
    jdbc:Parameter timestampzVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };

    jdbc:Parameter?[] paramBatch1 = [id, dateVal, timeVal, timezVal, timestampVal, timestampzVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-03-27-08:01" };
    timeVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999" };
    timezVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999+08:33" };
    timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };
    timestampzVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "2004-10-19T10:23:54+02:00" };

    jdbc:Parameter?[] paramBatch2 = [id, dateVal, timeVal, timezVal, timestampVal, timestampzVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_DATETIME_TYPES", 6, paramBatch1, paramBatch2);
}


function runInsertQueryWithParams(string tableName, int paramCount, jdbc:Parameter?[]... parameters)
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
    jdbc:BatchUpdateResult result = testDB->batchUpdate("INSERT INTO " + tableName + " VALUES(" + paramString + ")",
    false, ...parameters);

    int[] updatedRowCounts = result.updatedRowCount;
    jdbc:Error? e = result.returnedError;

    int[] | error ret;

    if (e is jdbc:Error) {
        ret = e;
    } else {
        ret = updatedRowCounts;
    }
    return ret;
}

function stopDatabaseClient() {
    checkpanic testDB.stop();
}


