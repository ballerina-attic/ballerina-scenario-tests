/*
 *  Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package org.ballerinalang.scenario.test.database.mssql;

public class Constants {
    public static final String MSSQL_JDBC_URL_KEY = "database.mssql.test.jdbc.url";
    public static final String MSSQL_JDBC_USERNAME_KEY = "database.mssql.test.jdbc.username";
    public static final String MSSQL_JDBC_PASSWORD_KEY = "database.mssql.test.jdbc.password";
    public static final String MSSQL_TESTNG_GROUP = "mssql";

    public static String BIT_VAL_FIELD = "bitVal";
    public static String TINYINT_VAL_FIELD = "tinyIntVal";
    public static String SMALLINT_VAL_FIELD = "smallIntVal";
    public static String MEDIUMINT_VAL_FIELD = "mediumIntVal";
    public static String INT_VAL_FIELD = "intVal";
    public static String BIGINT_VAL_FIELD = "bigIntVal";
    public static String DECIMAL_VAL_FIELD = "decimalVal";
    public static String NUMERIC_VAL_FIELD = "numericVal";
    public static String MONEY_VAL_FIELD = "moneyVal";
    public static String SMALLMONEY_VAL_FIELD = "smallMoneyVal";

    public static String FLOAT_VAL_FIELD = "floatVal";
    public static String REAL_VAL_FIELD = "realVal";

    public static String BINARY_FIELD = "binaryVal";
    public static String VARBINARY_FIELD = "varBinaryVal";
    public static String IMAGE_FIELD = "imageVal";
}
