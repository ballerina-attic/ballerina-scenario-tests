package org.ballerinalang.scenario.test.database.mysql;

public class SqlQueries {
    public class DdlTables {
        public static final String SELECT_UPDATE_TEST_NUMERIC_TYPES = "CREATE TABLE IF NOT EXISTS "
                + "SELECT_UPDATE_TEST_NUMERIC_TYPES(ID INT,BIT_VAL BIT(8),TINYINT_VAL TINYINT,SMALLINT_VAL SMALLINT,"
                + "MEDIUMINT_VAL MEDIUMINT,INTEGER_VAL INT,BIGINT_VAL BIGINT,DECIMAL_VAL DECIMAL(5,2),NUMERIC_VAL "
                + "NUMERIC"
                + "(7,3));";

        public static final String SELECT_UPDATE_TEST_FLOAT_TYPES = "CREATE TABLE IF NOT EXISTS "
                + "SELECT_UPDATE_TEST_FLOAT_TYPES(ID INT,FLOAT_VAL FLOAT,DOUBLE_VAL DOUBLE);";

        public static final String SELECT_UPDATE_TEST_STRING_TYPES = "CREATE TABLE IF NOT EXISTS "
                + "SELECT_UPDATE_TEST_STRING_TYPES(ID INT,CHAR_VAL CHAR(20),VARCHAR_VAL VARCHAR(20),TINYTEXT_VAL "
                + "TINYTEXT,TEXT_VAL TEXT,MEDIUMTEXT_VAL MEDIUMTEXT,LONGTEXT_VAL LONGTEXT,SET_VAL SET('A', 'B', 'C', "
                + "'D')"
                + ",ENUM_VAL ENUM('X', 'Y', 'Z', 'W', 'V'));";

        public static final String SELECT_UPDATE_TEST_COMPLEX_TYPES = "CREATE TABLE IF NOT EXISTS "
                + "SELECT_UPDATE_TEST_COMPLEX_TYPES(ID INT,BINARY_VAL BINARY(100),VARBINARY_VAL VARBINARY(100),"
                + "TINYBLOB_VAL TINYBLOB,BLOB_VAL BLOB,MEDIUMBLOB_VAL MEDIUMBLOB,LONGBLOB_VAL LONGBLOB);";

        public static final String SELECT_UPDATE_TEST_DATETIME_TYPES = "CREATE TABLE IF NOT EXISTS "
                + "SELECT_UPDATE_TEST_DATETIME_TYPES(ID INT,DATE_VAL DATE,TIME_VAL TIME,DATETIME_VAL DATETIME(3),"
                + "TIMESTAMP_VAL TIMESTAMP,YEAR_VAL YEAR);";

        public static final String UPDATE_TEST_GENERATED_KEYS =
                "CREATE TABLE IF NOT EXISTS UPDATE_TEST_GENERATED_KEYS(ID"
                        + " INT NOT NULL AUTO_INCREMENT,COL1  VARCHAR(20),COL2  INT,PRIMARY KEY (ID));";

        public static final String UPDATE_TEST_GENERATED_KEYS_NO_KEY = "CREATE TABLE IF NOT EXISTS "
                + "UPDATE_TEST_GENERATED_KEYS_NO_KEY(ID INT,COL1  VARCHAR(20),COL2  INT,PRIMARY KEY (ID));";

        public static final String DDL_TEST_ALTER_TABLE = "CREATE TABLE DDL_TEST_ALTER_TABLE(X INTEGER,Y VARCHAR(20),"
                + "PRIMARY KEY (X));";

        public static final String DDL_TEST_TABLE = "CREATE TABLE DDL_TEST_TABLE(X INTEGER,Y VARCHAR(20));";

        public static final String DDL_TEST_DROP_INDEX = "CREATE INDEX DDL_TEST_DROP_INDEX ON DDL_TEST_TABLE (X);";

        public static final String DDL_TEST_DROP_TABLE = "CREATE TABLE DDL_TEST_DROP_TABLE(X INTEGER,Y VARCHAR(20));";

        public static final String DDL_TEST_DROPPING_PROC =
                "CREATE PROCEDURE DDL_TEST_DROPPING_PROC(IN X INTEGER, OUT Y "
                        + "VARCHAR(50), INOUT Z VARCHAR(10)) READS SQL DATABEGINSELECT \"DDL_TEST_CREATE_PROC "
                        + "called\"END";

        public static final String CALL_TEST_RETURN_VALUES =
                "CREATE TABLE CALL_TEST_RETURN_VALUES (ID INT, VAL VARCHAR" + "(20));";
    }


    public class DdlStoredProcedures {
        public static final String CALL_TEST_OUT_NUMERIC_TYPES = "CREATE PROCEDURE CALL_TEST_OUT_NUMERIC_TYPES " + ""
                + "(IN p_id INTEGER, OUT p_bitVal BIT, OUT p_tinyIntVal TINYINT,"
                + "OUT p_smallIntVal SMALLINT, OUT p_mediumIntVal MEDIUMINT, OUT p_intVal INT, OUT p_bigIntVal BIGINT,"
                + "OUT p_decimalVal DECIMAL(5,2), OUT p_numericVal NUMERIC(7,3))\n" + "READS SQL DATA\n" + "BEGIN\n"
                + "    SELECT BIT_VAL INTO p_bitVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = p_id;\n"
                + "    SELECT TINYINT_VAL INTO p_tinyIntVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = p_id;\n"
                + "    SELECT SMALLINT_VAL INTO p_smallIntVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = p_id;\n"
                + "    SELECT MEDIUMINT_VAL INTO p_mediumIntVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = p_id;\n"
                + "    SELECT INTEGER_VAL INTO p_intVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = p_id;\n" + ""
                + "    SELECT BIGINT_VAL INTO p_bigIntVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = p_id;\n"
                + "    SELECT DECIMAL_VAL INTO p_decimalVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = p_id;\n"
                + "    SELECT NUMERIC_VAL INTO p_numericVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = p_id;\n"
                + "END";

        public static final String CALL_TEST_INOUT_NUMERIC_TYPES = "CREATE PROCEDURE CALL_TEST_INOUT_NUMERIC_TYPES "
                + "(IN p_id_in INTEGER, IN p_id_out INTEGER, INOUT p_bitVal BIT(8), INOUT p_tinyIntVal TINYINT,"
                + "INOUT p_smallIntVal SMALLINT, INOUT p_mediumIntVal MEDIUMINT, INOUT p_intVal INT, " + "INOUT "
                + "p_bigIntVal BIGINT,INOUT p_decimalVal DECIMAL(5,2), INOUT p_numericVal NUMERIC(7,3))\n"
                + "MODIFIES SQL DATA\n" + "BEGIN\n" + "    INSERT INTO SELECT_UPDATE_TEST_NUMERIC_TYPES VALUES" + ""
                + "(p_id_in, p_bitVal, p_tinyIntVal, p_smallIntVal, p_mediumIntVal,\n"
                + "    p_intVal, p_bigIntVal, p_decimalVal, p_numericVal);\n"
                + "    SELECT BIT_VAL INTO p_bitVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = p_id_out;\n"
                + "    SELECT TINYINT_VAL INTO p_tinyIntVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = "
                + "p_id_out;\n"
                + "    SELECT SMALLINT_VAL INTO p_smallIntVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = "
                + "p_id_out;\n"
                + "    SELECT MEDIUMINT_VAL INTO p_mediumIntVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = "
                + "p_id_out;\n"
                + "    SELECT INTEGER_VAL INTO p_intVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = p_id_out;\n"
                + "    SELECT BIGINT_VAL INTO p_bigIntVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = p_id_out;\n"
                + "    SELECT DECIMAL_VAL INTO p_decimalVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = "
                + "p_id_out;\n"
                + "    SELECT NUMERIC_VAL INTO p_numericVal FROM SELECT_UPDATE_TEST_NUMERIC_TYPES WHERE ID = p_id_out;\n"
                + "END";

        public static final String CALL_TEST_OUT_STRING_TYPES = "CREATE PROCEDURE CALL_TEST_OUT_STRING_TYPES "
                + "(IN p_id INTEGER, OUT p_charVal CHAR(20), OUT p_varcharVal VARCHAR(20),"
                + "OUT p_tinyTextVal TINYTEXT, OUT p_textVal TEXT, OUT p_mediumTextVal MEDIUMTEXT,"
                + "OUT p_longTextVal LONGTEXT, OUT p_setVal VARCHAR(5), OUT p_enumVal VARCHAR(5))" + "READS SQL DATA"
                + "BEGIN\n"
                + "    SELECT CHAR_VAL INTO p_charVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = p_id;\n"
                + "    SELECT VARCHAR_VAL INTO p_varcharVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = p_id;\n"
                + "    SELECT TINYTEXT_VAL INTO p_tinyTextVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = p_id;\n"
                + "    SELECT TEXT_VAL INTO p_textVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = p_id;\n"
                + "    SELECT MEDIUMTEXT_VAL INTO p_mediumTextVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = "
                + "p_id;\n"
                + "    SELECT LONGTEXT_VAL INTO p_longTextVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = p_id;\n"
                + "    SELECT SET_VAL INTO p_setVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = p_id;\n"
                + "    SELECT ENUM_VAL INTO p_enumVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = p_id;\n" + "END";

        public static final String CALL_TEST_INOUT_STRING_TYPES = "CREATE PROCEDURE CALL_TEST_INOUT_STRING_TYPES "
                + "(IN p_id_in INTEGER, IN p_id_out INTEGER, INOUT p_charVal CHAR(20), INOUT p_varcharVal VARCHAR(20),"
                + "INOUT p_tinyTextVal TINYTEXT, INOUT p_textVal TEXT, INOUT p_mediumTextVal MEDIUMTEXT,"
                + "INOUT p_longTextVal LONGTEXT, INOUT p_setVal VARCHAR(5), INOUT p_enumVal VARCHAR(5))"
                + "MODIFIES SQL DATA\n" + "BEGIN\n"
                + "    INSERT INTO SELECT_UPDATE_TEST_STRING_TYPES VALUES(p_id_in, p_charVal, p_varcharVal, "
                + "    p_tinyTextVal, p_textVal,p_mediumTextVal, p_longTextVal, p_setVal, p_enumVal);\n"
                + "    SELECT CHAR_VAL INTO p_charVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = p_id_out;\n"
                + "    SELECT VARCHAR_VAL INTO p_varcharVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = p_id_out;\n"
                + "    SELECT TINYTEXT_VAL INTO p_tinyTextVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = "
                + "p_id_out;\n"
                + "    SELECT TEXT_VAL INTO p_textVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = p_id_out;\n"
                + "    SELECT MEDIUMTEXT_VAL INTO p_mediumTextVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = "
                + "    p_id_out;\n"
                + "    SELECT LONGTEXT_VAL INTO p_longTextVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = "
                + "p_id_out;\n"
                + "    SELECT SET_VAL INTO p_setVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = p_id_out;\n" + " "
                + "   SELECT ENUM_VAL INTO p_enumVal FROM SELECT_UPDATE_TEST_STRING_TYPES WHERE ID = p_id_out;\n"
                + "END";

        public static final String CALL_TEST_OUT_DATETIME_TYPES = "CREATE PROCEDURE CALL_TEST_OUT_DATETIME_TYPES "
                + "(IN p_id INTEGER, OUT p_dateInt DATE, OUT P_timeInt TIME,OUT p_dateTimeInt DATETIME, "
                + "OUT p_timestampInt TIMESTAMP)\n" + "READS SQL DATA\n" + "BEGIN\n"
                + "    SELECT DATE_VAL INTO p_dateInt FROM SELECT_UPDATE_TEST_DATETIME_TYPES WHERE ID = p_id;\n"
                + "    SELECT TIME_VAL INTO P_timeInt FROM SELECT_UPDATE_TEST_DATETIME_TYPES WHERE ID = p_id;\n"
                + "    SELECT DATETIME_VAL INTO p_dateTimeInt FROM SELECT_UPDATE_TEST_DATETIME_TYPES WHERE ID = p_id;\n"
                + "    SELECT TIMESTAMP_VAL INTO p_timestampInt FROM SELECT_UPDATE_TEST_DATETIME_TYPES WHERE ID = p_id;\n"
                + "END";

        public static final String CALL_TEST_INOUT_DATETIME_TYPES = "CREATE PROCEDURE CALL_TEST_INOUT_DATETIME_TYPES "
                + "(IN p_id_in INTEGER, IN p_id_out INTEGER, INOUT p_dateInt DATE, INOUT P_timeInt TIME,"
                + "INOUT p_dateTimeInt DATETIME, INOUT p_timestampInt TIMESTAMP)\n" + "READS SQL DATA\n" + "BEGIN\n"
                + "    INSERT INTO SELECT_UPDATE_TEST_DATETIME_TYPES (ID, DATE_VAL, TIME_VAL, DATETIME_VAL,"
                + "TIMESTAMP_VAL)\n"
                + "    VALUES(p_id_in, p_dateInt, P_timeInt, p_dateTimeInt, p_timestampInt);\n" + "\n"
                + "    SELECT DATE_VAL INTO p_dateInt FROM SELECT_UPDATE_TEST_DATETIME_TYPES WHERE ID = p_id_out;\n"
                + "    SELECT TIME_VAL INTO P_timeInt FROM SELECT_UPDATE_TEST_DATETIME_TYPES WHERE ID = p_id_out;\n"
                + "    SELECT DATETIME_VAL INTO p_dateTimeInt FROM SELECT_UPDATE_TEST_DATETIME_TYPES WHERE ID = "
                + "p_id_out;\n"
                + "    SELECT TIMESTAMP_VAL INTO p_timestampInt FROM SELECT_UPDATE_TEST_DATETIME_TYPES WHERE ID = "
                + "    p_id_out;\n" + "END";

        public static final String CALL_TEST_OUT_COMPLEX_TYPES = "CREATE PROCEDURE CALL_TEST_OUT_COMPLEX_TYPES "
                + "(IN p_id INTEGER, OUT p_binaryVal BINARY(100), OUT p_varBinaryVal VARBINARY(100),"
                + "OUT p_tinyBlobVal TINYBLOB, OUT p_blobVal BLOB, OUT p_mediumBlobVal MEDIUMBLOB, "
                + "OUT p_longBlobVal LONGBLOB)\n" + "READS SQL DATA\n" + "BEGIN\n"
                + "    SELECT BINARY_VAL INTO p_binaryVal FROM SELECT_UPDATE_TEST_COMPLEX_TYPES WHERE ID = p_id;\n"
                + "    SELECT VARBINARY_VAL INTO p_varBinaryVal FROM SELECT_UPDATE_TEST_COMPLEX_TYPES WHERE ID = "
                + "p_id;\n"
                + "    SELECT TINYBLOB_VAL INTO p_tinyBlobVal FROM SELECT_UPDATE_TEST_COMPLEX_TYPES WHERE ID = p_id;\n"
                + "    SELECT BLOB_VAL INTO p_blobVal FROM SELECT_UPDATE_TEST_COMPLEX_TYPES WHERE ID = p_id;\n"
                + "    SELECT MEDIUMBLOB_VAL INTO p_mediumBlobVal FROM SELECT_UPDATE_TEST_COMPLEX_TYPES WHERE ID = "
                + "p_id;\n"
                + "    SELECT LONGBLOB_VAL INTO p_longBlobVal FROM SELECT_UPDATE_TEST_COMPLEX_TYPES WHERE ID = p_id;\n"
                + "END";

        public static final String CALL_TEST_INOUT_COMPLEX_TYPES = "CREATE PROCEDURE CALL_TEST_INOUT_COMPLEX_TYPES "
                + "(IN p_id_in INTEGER, IN p_id_out INTEGER, INOUT p_binaryVal BINARY(100),"
                + "INOUT p_varBinaryVal VARBINARY(100), INOUT p_tinyBlobVal TINYBLOB, INOUT p_blobVal BLOB, "
                + "INOUT p_mediumBlobVal MEDIUMBLOB,INOUT p_longBlobVal LONGBLOB)\n" + "MODIFIES SQL DATA\n"
                + "BEGIN\n"
                + "    INSERT INTO SELECT_UPDATE_TEST_COMPLEX_TYPES VALUES(p_id_in, p_binaryVal, p_varBinaryVal, "
                + "    p_tinyBlobVal, p_blobVal, p_mediumBlobVal, p_longBlobVal);\n"
                + "    SELECT BINARY_VAL INTO p_binaryVal FROM SELECT_UPDATE_TEST_COMPLEX_TYPES WHERE ID = p_id_out;\n"
                + "    SELECT VARBINARY_VAL INTO p_varBinaryVal FROM SELECT_UPDATE_TEST_COMPLEX_TYPES WHERE ID = "
                + "p_id_out;\n"
                + "    SELECT TINYBLOB_VAL INTO p_tinyBlobVal FROM SELECT_UPDATE_TEST_COMPLEX_TYPES WHERE ID = "
                + "p_id_out;\n"
                + "    SELECT BLOB_VAL INTO p_blobVal FROM SELECT_UPDATE_TEST_COMPLEX_TYPES WHERE ID = p_id_out;\n"
                + "    SELECT MEDIUMBLOB_VAL INTO p_mediumBlobVal FROM SELECT_UPDATE_TEST_COMPLEX_TYPES WHERE ID = "
                + "p_id_out;\n"
                + "    SELECT LONGBLOB_VAL INTO p_longBlobVal FROM SELECT_UPDATE_TEST_COMPLEX_TYPES WHERE ID = "
                + "p_id_out;\n"
                + "END";

        public static final String CALL_TEST_OUT_FLOAT_TYPES = "CREATE PROCEDURE CALL_TEST_OUT_FLOAT_TYPES "
                + "(IN p_id INTEGER, OUT p_floatVal FLOAT, OUT p_doubleVal DOUBLE)\n" + "READS SQL DATA\n"
                + "BEGIN\n"
                + "    SELECT FLOAT_VAL INTO p_floatVal FROM SELECT_UPDATE_TEST_FLOAT_TYPES WHERE ID = p_id;\n"
                + "    SELECT DOUBLE_VAL INTO p_doubleVal FROM SELECT_UPDATE_TEST_FLOAT_TYPES WHERE ID = p_id;\n"
                + "END";

        public static final String CALL_TEST_INOUT_FLOAT_TYPES = "CREATE PROCEDURE CALL_TEST_INOUT_FLOAT_TYPES "
                + "(IN p_id INTEGER, INOUT p_floatVal FLOAT, INOUT p_doubleVal DOUBLE)\n" + "MODIFIES SQL DATA\n"
                + "BEGIN\n"
                + "    INSERT INTO SELECT_UPDATE_TEST_FLOAT_TYPES VALUES(p_id, p_floatVal, p_doubleVal);\n"
                + "    SELECT FLOAT_VAL INTO p_floatVal FROM SELECT_UPDATE_TEST_FLOAT_TYPES WHERE ID = p_id;\n"
                + "    SELECT DOUBLE_VAL INTO p_doubleVal FROM SELECT_UPDATE_TEST_FLOAT_TYPES WHERE ID = p_id;\n"
                + "END";

        public static final String CALL_TEST_RETURN_RESULTSET =
                "CREATE PROCEDURE CALL_TEST_RETURN_RESULTSET(IN p_id INTEGER)\n"
                        + "READS SQL DATA\n"
                        + "BEGIN\n"
                        + "  SELECT * FROM CALL_TEST_RETURN_VALUES;\n"
                        + "END";

    }

}
