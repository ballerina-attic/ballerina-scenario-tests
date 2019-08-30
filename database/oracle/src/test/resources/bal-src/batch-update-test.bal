import ballerina/config;
import ballerinax/java.jdbc;

jdbc:Client testDB =  new jdbc:Client({
    url: config:getAsString("database.oracle.test.jdbc.url"),
    username: config:getAsString("database.oracle.test.jdbc.username"),
    password: config:getAsString("database.oracle.test.jdbc.password")
});

function testBatchUpdateIntegerTypesWithParams() returns int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 1234 };

    jdbc:Parameter?[] paramBatch1 = [id, intVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    intVal = { sqlType: jdbc:TYPE_INTEGER, value: 1238 };

    jdbc:Parameter?[] paramBatch2 = [id, intVal];

    return runInsertQueryWithParams("SELECT_UPDATE_INTEGER_TYPES", 2, paramBatch1, paramBatch2);
}

function testBatchUpdateFixedPointTypesWithParams() returns int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 999.125698 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 109999.123412378914545 };

    jdbc:Parameter?[] paramBatch1 = [id, numericVal, decimalVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 969.124698 };
    decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 145699.123412978914545 };

    jdbc:Parameter?[] paramBatch2 = [id, numericVal, decimalVal];

    return runInsertQueryWithParams("SELECT_UPDATE_FIXEDPOINT_TYPES", 3, paramBatch1, paramBatch2);
}

function testUpdateFloatingPointTypesWithParams() returns int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter binaryFloat = { sqlType: jdbc:TYPE_FLOAT, value: 359.125698 };
    jdbc:Parameter binaryDouble = { sqlType: jdbc:TYPE_DOUBLE, value: 109199.12341437891454 };

    jdbc:Parameter?[] paramBatch1 = [id, binaryFloat, binaryDouble];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    binaryFloat = { sqlType: jdbc:TYPE_FLOAT, value: 999.128698 };
    binaryDouble = { sqlType: jdbc:TYPE_DOUBLE, value: 109999.723412378914545 };

    jdbc:Parameter?[] paramBatch2 = [id, binaryFloat, binaryDouble];

    return runInsertQueryWithParams("SELECT_UPDATE_FLOAT_TYPES", 3, paramBatch1, paramBatch2);
}


function testBatchUpdateStringTypesWithParams() returns int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, value: "Char Column" };
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, value: "යූනිකෝඩ් දත්ත" };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column" };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, value: "යූනිකෝඩ් දත්ත" };

    jdbc:Parameter?[] paramBatch1 = [id, charVal, ncharVal, varcharVal, nvarcharVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    charVal = { sqlType: jdbc:TYPE_CHAR, value: "Char Column" };
    ncharVal = { sqlType: jdbc:TYPE_NCHAR, value: "යූනිකෝඩ් දත්ත" };
    varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column" };
    nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, value: "යූනිකෝඩ් දත්ත" };

    jdbc:Parameter?[] paramBatch2 = [id, charVal, ncharVal, varcharVal, nvarcharVal];

    return runInsertQueryWithParams("SELECT_UPDATE_STRING_TYPES", 5, paramBatch1, paramBatch2);
}

function testBatchUpdateComplexTypesWithParams() returns int[] | error {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter blobVal =  { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4=" };
    jdbc:Parameter clobVal = { sqlType: jdbc:TYPE_CLOB, value: "Clob Column" };
    jdbc:Parameter nclobVal = { sqlType: jdbc:TYPE_NCLOB, value: "යූනිකෝඩ් දත්ත" };

    jdbc:Parameter?[] paramBatch1 = [id, blobVal, clobVal, nclobVal];

    id =  { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    blobVal =  { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4=" };
    clobVal = { sqlType: jdbc:TYPE_CLOB, value: "Clob Column" };
    nclobVal = { sqlType: jdbc:TYPE_NCLOB, value: "යූනිකෝඩ් දත්ත" };

    jdbc:Parameter?[] paramBatch2 = [id, blobVal, clobVal, nclobVal];

    return runInsertQueryWithParams("SELECT_UPDATE_COMPLEX_TYPES", 4, paramBatch1, paramBatch2);
}

function testBatchUpdateDateTimeWithValuesParam() returns int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-03-27-08:01" };
    jdbc:Parameter timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1948-02-04T01:05:15.999-08:00" };
    jdbc:Parameter timestampTzVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };
    jdbc:Parameter timestampTzLocalVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };

    jdbc:Parameter?[] paramBatch1 = [id, dateVal, timestampVal, timestampTzVal, timestampTzLocalVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-03-27-08:01" };
    timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1948-02-04T01:05:15.999-08:00" };
    timestampTzVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };
    timestampTzLocalVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };

    jdbc:Parameter?[] paramBatch2 = [id, dateVal, timestampVal, timestampTzVal, timestampTzLocalVal];

    return runInsertQueryWithParams("SELECT_UPDATE_DATETIME_TYPES", 5, paramBatch1, paramBatch2);
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
