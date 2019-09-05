import ballerina/config;
import ballerinax/java.jdbc;

jdbc:Client testDB = new({
    url: config:getAsString("database.mssql.test.jdbc.url"),
    username: config:getAsString("database.mssql.test.jdbc.username"),
    password: config:getAsString("database.mssql.test.jdbc.password")
});

function testBatchUpdateIntegerTypesWithParams() returns @tainted int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 32767 };
    jdbc:Parameter bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 9223372036854775807 };
    jdbc:Parameter tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, value: 255 };
    jdbc:Parameter bitVal = { sqlType: jdbc:TYPE_BIT, value: true };
    jdbc:Parameter intVal = { sqlType: jdbc:TYPE_INTEGER, value: 2147483647 };

    jdbc:Parameter?[] paramBatch1 = [id, smallIntVal, bigIntVal, tinyIntVal, bitVal, intVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    smallIntVal = { sqlType: jdbc:TYPE_SMALLINT, value: 53235 };
    bigIntVal = { sqlType: jdbc:TYPE_BIGINT, value: 9223372036854771111 };
    tinyIntVal = { sqlType: jdbc:TYPE_TINYINT, value: 245 };
    bitVal = { sqlType: jdbc:TYPE_BIT, value: true };
    intVal = { sqlType: jdbc:TYPE_INTEGER, value: 2134283647 };

    jdbc:Parameter?[] paramBatch2 = [id, smallIntVal, bigIntVal, tinyIntVal, bitVal, intVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_INTEGER_TYPES", 6, paramBatch1, paramBatch2);
}

function testBatchUpdateFixedPointTypesWithParams() returns @tainted int[] | error {
    decimal dec = 922337203685477.5807;
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 10.05 };
    jdbc:Parameter numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1.051 };
    jdbc:Parameter moneyVal = { sqlType: jdbc:TYPE_DECIMAL, value: dec };
    jdbc:Parameter smallMoneyVal = { sqlType: jdbc:TYPE_DECIMAL, value: 214748.3647 };

    jdbc:Parameter?[] paramBatch1 = [id, decimalVal, numericVal, moneyVal, smallMoneyVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    decimalVal = { sqlType: jdbc:TYPE_DECIMAL, value: 10.05 };
    numericVal = { sqlType: jdbc:TYPE_NUMERIC, value: 1.051 };
    moneyVal = { sqlType: jdbc:TYPE_DECIMAL, value: dec };
    smallMoneyVal = { sqlType: jdbc:TYPE_DECIMAL, value: 214748.3647 };

    jdbc:Parameter?[] paramBatch2 = [id, decimalVal, numericVal, moneyVal, smallMoneyVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_FIXED_POINT_TYPES", 5, paramBatch1, paramBatch2);
}

function testBatchUpdateFloatingPointTypesWithParams() returns @tainted int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter floatVal = { sqlType: jdbc:TYPE_FLOAT, value: 782.45908 };
    jdbc:Parameter realVal = { sqlType: jdbc:TYPE_REAL, value:  8234.563};

    jdbc:Parameter?[] paramBatch1 = [id, floatVal, realVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    floatVal = { sqlType: jdbc:TYPE_FLOAT, value: 123.45678 };
    realVal = { sqlType: jdbc:TYPE_REAL, value:  1234.567};

    jdbc:Parameter?[] paramBatch2 = [id, floatVal, realVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_FLOAT_TYPES", 3, paramBatch1, paramBatch2);
}

function testBatchUpdateStringTypes() returns @tainted int[] | error {
    jdbc:Parameter id = { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter charVal = { sqlType: jdbc:TYPE_CHAR, value: "ABCD" };
    jdbc:Parameter varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "SQL Server VARCHAR" };
    jdbc:Parameter textVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "This is test message" };
    jdbc:Parameter ncharVal = { sqlType: jdbc:TYPE_NCHAR, value: "MS" };
    jdbc:Parameter nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, value: "0E984725Ac" };
    jdbc:Parameter ntextVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "Text" };

    jdbc:Parameter?[] paramBatch1 = [id, charVal, varcharVal, textVal, ncharVal, nvarcharVal, ntextVal];

    id = { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    charVal = { sqlType: jdbc:TYPE_CHAR, value: "ABCD" };
    varcharVal = { sqlType: jdbc:TYPE_VARCHAR, value: "SQL Server VARCHAR" };
    textVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "This is test message" };
    ncharVal = { sqlType: jdbc:TYPE_NCHAR, value: "MS" };
    nvarcharVal = { sqlType: jdbc:TYPE_NVARCHAR, value: "0E984725Ac" };
    ntextVal = { sqlType: jdbc:TYPE_LONGNVARCHAR, value: "Text" };

    jdbc:Parameter?[] paramBatch2 = [id, charVal, varcharVal, textVal, ncharVal, nvarcharVal, ntextVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_STRING_TYPES", 7, paramBatch1, paramBatch2);
}

function testBatchUpdateComplexTypes() returns @tainted int[] | error {
    jdbc:Parameter id =  { sqlType: jdbc:TYPE_INTEGER, value: 1 };
    jdbc:Parameter binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    jdbc:Parameter varBinaryVal = { sqlType: jdbc:TYPE_VARBINARY, value: "dmFyYmluYXJ5IENvbHVtbg==" };
    jdbc:Parameter imageVal = { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4" };

    jdbc:Parameter?[] paramBatch1 = [id, binaryVal, varBinaryVal, imageVal];

    id =  { sqlType: jdbc:TYPE_INTEGER, value: 2 };
    binaryVal =  { sqlType: jdbc:TYPE_BINARY, value: "QmluYXJ5IENvbHVtbg==" };
    varBinaryVal = { sqlType: jdbc:TYPE_VARBINARY, value: "dmFyYmluYXJ5IENvbHVtbg==" };
    imageVal = { sqlType: jdbc:TYPE_BLOB, value: "QmxvYiBDb2x1bW4" };

    jdbc:Parameter?[] paramBatch2 = [id, binaryVal, varBinaryVal, imageVal];

    return runInsertQueryWithParams("SELECT_UPDATE_TEST_COMPLEX_TYPES", 4, paramBatch1, paramBatch2);
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
