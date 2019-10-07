import ballerina/config;
import ballerinax/java.jdbc;

jdbc:Client testDB =  new jdbc:Client({
        url: config:getAsString("database.mysql.test.jdbc.url"),
        username: config:getAsString("database.mysql.test.jdbc.username"),
        password: config:getAsString("database.mysql.test.jdbc.password")
    });

function testBatchUpdateIntgerTypesWithParams() returns int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter bitVal = { sqlType: jdbc:TYPE_BIT, value: true };
    jdbc:Parameter tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, value: 126 };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32765 };
    jdbc:Parameter mediumIntVal = { sqlType: jdbc:TYPE_INTEGER, value: 32765 };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 8388603 };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 2147483644 };

    jdbc:Parameter?[] paramBatch1 = [id, bitVal, tinyIntVal, smallIntVal, mediumIntVal, intVal, bigIntVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    bitVal = { sqlType: jdbc:TYPE_BIT, value: true };
    tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, value: 126 };
    smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32765 };
    mediumIntVal = { sqlType: jdbc:TYPE_INTEGER, value: 32765 };
    intVal = { sqlType: jdbc:TYPE_INTEGER, value: 8389603 };
    bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 2147489144 };

    jdbc:Parameter?[] paramBatch2 = [id, bitVal, tinyIntVal, smallIntVal, mediumIntVal, intVal, bigIntVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_INTEGER_TYPES", 7, paramBatch1, paramBatch2);
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
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, value: "Char Column" };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column" };
    jdbc:Parameter tinyTextVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "TinyText column" };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "Text column" };
    jdbc:Parameter mediumTextVal = { sqlType: jdbc:TYPE_CLOB, value: "MediumText column" };
    jdbc:Parameter longTextVal = { sqlType: jdbc:TYPE_CLOB, value: "LongText column" };
    jdbc:Parameter setVal = { sqlType: jdbc:TYPE_VARCHAR, value: "A" };
    jdbc:Parameter enumVal = { sqlType: jdbc:TYPE_VARCHAR, value: "X" };

    jdbc:Parameter?[] paramBatch1 = [id, charVal, varcharVal, tinyTextVal, textVal, mediumTextVal, longTextVal, setVal, enumVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    charVal = { sqlType: jdbc:TYPE_CHAR, value: "Char Column" };
    varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "Varchar column" };
    tinyTextVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "TinyText column" };
    textVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "Text column" };
    mediumTextVal = { sqlType: jdbc:TYPE_CLOB, value: "MediumText column" };
    longTextVal = { sqlType: jdbc:TYPE_CLOB, value: "LongText column" };
    setVal = { sqlType: jdbc:TYPE_VARCHAR, value: "A" };
    enumVal = { sqlType: jdbc:TYPE_VARCHAR, value: "X" };

    jdbc:Parameter?[] paramBatch2 = [id, charVal, varcharVal, tinyTextVal, textVal, mediumTextVal, longTextVal, setVal, enumVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_STRING_TYPES", 9, paramBatch1, paramBatch2);
}

function testBatchUpdateComplexTypesWithParams() returns int[] | error {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    jdbc:Parameter varBinaryVal = { sqlType: jdbc:TYPE_VARBINARY, value: "dmFyYmluYXJ5IENvbHVtbg==" };
    jdbc:Parameter tinyBlobVal = { sqlType: jdbc:TYPE_BLOB, value: "VGlueUJsb2IgQ29sdW1u" };
    jdbc:Parameter blobVal = { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4" };
    jdbc:Parameter mediumBlobVal = { sqlType: jdbc:TYPE_BLOB, value: "TWVkaXVtQmxvYiBDb2x1bW4=" };
    jdbc:Parameter longBlobVal = { sqlType: jdbc:TYPE_BLOB, value: "TG9uZ0Jsb2IgQ29sdW1u" };

    jdbc:Parameter?[] paramBatch1 = [id, binaryVal, varBinaryVal, tinyBlobVal, blobVal, mediumBlobVal, longBlobVal];

    id =  { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    varBinaryVal = { sqlType: jdbc:TYPE_VARBINARY, value: "dmFyYmluYXJ5IENvbHVtbg==" };
    tinyBlobVal = { sqlType: jdbc:TYPE_BLOB, value: "VGlueUJsb2IgQ29sdW1u" };
    blobVal = { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4" };
    mediumBlobVal = { sqlType: jdbc:TYPE_BLOB, value: "TWVkaXVtQmxvYiBDb2x1bW4=" };
    longBlobVal = { sqlType: jdbc:TYPE_BLOB, value: "TG9uZ0Jsb2IgQ29sdW1u" };

    jdbc:Parameter?[] paramBatch2 = [id, binaryVal, varBinaryVal, tinyBlobVal, blobVal, mediumBlobVal, longBlobVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_COMPLEX_TYPES", 7, paramBatch1, paramBatch2);
}

function testBatchUpdateDateTimeWithValuesParam() returns int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-03-27-08:01" };
    jdbc:Parameter timeVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999+08:33" };
    jdbc:Parameter dateTimeVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1948-02-04T01:05:15.999-08:00" };
    jdbc:Parameter timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };
    jdbc:Parameter yearVal = { sqlType: jdbc:TYPE_INTEGER, value: "1991" };

    jdbc:Parameter?[] paramBatch1 = [ id, dateVal, timeVal, dateTimeVal, timestampVal, yearVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    dateVal = { sqlType: jdbc:TYPE_DATE, value: "2019-03-27-08:01" };
    timeVal = { sqlType: jdbc:TYPE_TIME, value: "17:43:21.999999+08:33" };
    dateTimeVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1948-02-04T01:05:15.999-08:00" };
    timestampVal = { sqlType: jdbc:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };
    yearVal = { sqlType: jdbc:TYPE_INTEGER, value: "1991" };

    jdbc:Parameter?[] paramBatch2 = [ id, dateVal, timeVal, dateTimeVal, timestampVal, yearVal];

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

