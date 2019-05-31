import ballerina/sql;
import ballerina/config;
import ballerinax/jdbc;

jdbc:Client testDB =  new jdbc:Client({
        url: config:getAsString("database.mysql.test.jdbc.url"),
        username: config:getAsString("database.mysql.test.jdbc.username"),
        password: config:getAsString("database.mysql.test.jdbc.password")
    });

function testBatchUpdateNumericTypesWithParams() returns int[] | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter bitVal = { sqlType: sql:TYPE_BIT, value: 1 };
    sql:Parameter tinyIntVal = { sqlType: sql:TYPE_TINYINT, value: 126 };
    sql:Parameter smallIntVal = { sqlType: sql:TYPE_SMALLINT, value: 32765 };
    sql:Parameter mediumIntVal = { sqlType: sql:TYPE_INTEGER, value: 32765 };
    sql:Parameter intVal = { sqlType: sql:TYPE_INTEGER, value: 8388603 };
    sql:Parameter bigIntVal = { sqlType: sql:TYPE_BIGINT, value: 2147483644 };
    sql:Parameter decimalVal = { sqlType: sql:TYPE_DECIMAL, value: 143.78 };
    sql:Parameter numericVal = { sqlType: sql:TYPE_NUMERIC, value: 1034.789 };

    sql:Parameter?[] paramBatch1 = [id, bitVal, tinyIntVal, smallIntVal, mediumIntVal, intVal, bigIntVal, decimalVal, numericVal];

    id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    bitVal = { sqlType: sql:TYPE_BIT, value: 1 };
    tinyIntVal = { sqlType: sql:TYPE_TINYINT, value: 126 };
    smallIntVal = { sqlType: sql:TYPE_SMALLINT, value: 32765 };
    mediumIntVal = { sqlType: sql:TYPE_INTEGER, value: 32765 };
    intVal = { sqlType: sql:TYPE_INTEGER, value: 8389603 };
    bigIntVal = { sqlType: sql:TYPE_BIGINT, value: 2147489144 };
    decimalVal = { sqlType: sql:TYPE_DECIMAL, value: 243.58 };
    numericVal = { sqlType: sql:TYPE_NUMERIC, value: 1134.769 };

    sql:Parameter?[] paramBatch2 = [id, bitVal, tinyIntVal, smallIntVal, mediumIntVal, intVal, bigIntVal, decimalVal, numericVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_NUMERIC_TYPES", 9, paramBatch1, paramBatch2);
}

function testBatchUpdateStringTypesWithParams() returns int[] | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter charVal = { sqlType: sql:TYPE_CHAR, value: "Char Column" };
    sql:Parameter varcharVal = { sqlType: sql:TYPE_VARCHAR, value: "Varchar column" };
    sql:Parameter tinyTextVal = { sqlType: sql:TYPE_LONGNVARCHAR, value: "TinyText column" };
    sql:Parameter textVal = { sqlType: sql:TYPE_LONGNVARCHAR, value: "Text column" };
    sql:Parameter mediumTextVal = { sqlType: sql:TYPE_CLOB, value: "MediumText column" };
    sql:Parameter longTextVal = { sqlType: sql:TYPE_CLOB, value: "LongText column" };
    sql:Parameter setVal = { sqlType: sql:TYPE_VARCHAR, value: "A" };
    sql:Parameter enumVal = { sqlType: sql:TYPE_VARCHAR, value: "X" };

    sql:Parameter?[] paramBatch1 = [id, charVal, varcharVal, tinyTextVal, textVal, mediumTextVal, longTextVal, setVal, enumVal];

    id = { sqlType: sql:TYPE_INTEGER, value: 2 };
    charVal = { sqlType: sql:TYPE_CHAR, value: "Char Column" };
    varcharVal = { sqlType: sql:TYPE_VARCHAR, value: "Varchar column" };
    tinyTextVal = { sqlType: sql:TYPE_LONGNVARCHAR, value: "TinyText column" };
    textVal = { sqlType: sql:TYPE_LONGNVARCHAR, value: "Text column" };
    mediumTextVal = { sqlType: sql:TYPE_CLOB, value: "MediumText column" };
    longTextVal = { sqlType: sql:TYPE_CLOB, value: "LongText column" };
    setVal = { sqlType: sql:TYPE_VARCHAR, value: "A" };
    enumVal = { sqlType: sql:TYPE_VARCHAR, value: "X" };

    sql:Parameter?[] paramBatch2 = [id, charVal, varcharVal, tinyTextVal, textVal, mediumTextVal, longTextVal, setVal, enumVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_STRING_TYPES", 9, paramBatch1, paramBatch2);
}

function testBatchUpdateComplexTypesWithParams() returns int[] | error {
    sql:Parameter id =  { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter binaryVal =  { sqlType: sql:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    sql:Parameter varBinaryVal = { sqlType: sql:TYPE_VARBINARY, value: "dmFyYmluYXJ5IENvbHVtbg==" };
    sql:Parameter tinyBlobVal = { sqlType: sql:TYPE_BLOB, value: "VGlueUJsb2IgQ29sdW1u" };
    sql:Parameter blobVal = { sqlType: sql:TYPE_BLOB, value: "QmxvYiBDb2x1bW4" };
    sql:Parameter mediumBlobVal = { sqlType: sql:TYPE_BLOB, value: "TWVkaXVtQmxvYiBDb2x1bW4=" };
    sql:Parameter longBlobVal = { sqlType: sql:TYPE_BLOB, value: "TG9uZ0Jsb2IgQ29sdW1u" };

    sql:Parameter?[] paramBatch1 = [id, binaryVal, varBinaryVal, tinyBlobVal, blobVal, mediumBlobVal, longBlobVal];

    id =  { sqlType: sql:TYPE_INTEGER, value: 2 };
    binaryVal =  { sqlType: sql:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    varBinaryVal = { sqlType: sql:TYPE_VARBINARY, value: "dmFyYmluYXJ5IENvbHVtbg==" };
    tinyBlobVal = { sqlType: sql:TYPE_BLOB, value: "VGlueUJsb2IgQ29sdW1u" };
    blobVal = { sqlType: sql:TYPE_BLOB, value: "QmxvYiBDb2x1bW4" };
    mediumBlobVal = { sqlType: sql:TYPE_BLOB, value: "TWVkaXVtQmxvYiBDb2x1bW4=" };
    longBlobVal = { sqlType: sql:TYPE_BLOB, value: "TG9uZ0Jsb2IgQ29sdW1u" };

    sql:Parameter?[] paramBatch2 = [id, binaryVal, varBinaryVal, tinyBlobVal, blobVal, mediumBlobVal, longBlobVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_COMPLEX_TYPES", 7, paramBatch1, paramBatch2);
}

function testBatchUpdateDateTimeWithValuesParam() returns int[] | error {
    sql:Parameter id = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter dateVal = { sqlType: sql:TYPE_DATE, value: "2019-03-27-08:01" };
    sql:Parameter timeVal = { sqlType: sql:TYPE_TIME, value: "17:43:21.999999+08:33" };
    sql:Parameter dateTimeVal = { sqlType: sql:TYPE_TIMESTAMP, value: "1948-02-04T01:05:15.999-08:00" };
    sql:Parameter timestampVal = { sqlType: sql:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };
    sql:Parameter yearVal = { sqlType: sql:TYPE_INTEGER, value: "1991" };

    sql:Parameter?[] paramBatch1 = [ id, dateVal, timeVal, dateTimeVal, timestampVal, yearVal];

    id = { sqlType: sql:TYPE_INTEGER, value: 2 };
    dateVal = { sqlType: sql:TYPE_DATE, value: "2019-03-27-08:01" };
    timeVal = { sqlType: sql:TYPE_TIME, value: "17:43:21.999999+08:33" };
    dateTimeVal = { sqlType: sql:TYPE_TIMESTAMP, value: "1948-02-04T01:05:15.999-08:00" };
    timestampVal = { sqlType: sql:TYPE_TIMESTAMP, value: "1970-02-01T01:05:15.999-08:00" };
    yearVal = { sqlType: sql:TYPE_INTEGER, value: "1991" };

    sql:Parameter?[] paramBatch2 = [ id, dateVal, timeVal, dateTimeVal, timestampVal, yearVal];

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

