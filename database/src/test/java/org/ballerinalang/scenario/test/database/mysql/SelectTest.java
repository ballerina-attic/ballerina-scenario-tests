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
package org.ballerinalang.scenario.test.database.mysql;

import org.ballerinalang.config.ConfigRegistry;
import org.ballerinalang.launcher.util.BCompileUtil;
import org.ballerinalang.launcher.util.BRunUtil;
import org.ballerinalang.launcher.util.CompileResult;
import org.ballerinalang.model.values.BBoolean;
import org.ballerinalang.model.values.BDecimal;
import org.ballerinalang.model.values.BFloat;
import org.ballerinalang.model.values.BInteger;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.model.values.BValueArray;
import org.ballerinalang.scenario.test.common.ScenarioTestBase;
import org.ballerinalang.scenario.test.common.database.DatabaseUtil;
import org.ballerinalang.scenario.test.database.util.AssertionUtil;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import java.math.BigDecimal;
import java.nio.charset.Charset;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Properties;

@Test(groups = "MySQLTest")
public class SelectTest extends ScenarioTestBase {
    private CompileResult selectCompileResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;
    private static long date;
    private static long time;
    private static long datetime;
    private static long timestamp;
    private static long dateRec;
    private static long timeRec;
    private static long datetimeRec;
    private static long timestampRec;

    @BeforeClass
    public void setup() throws Exception {
        Properties deploymentProperties = getDeploymentProperties();
        jdbcUrl = deploymentProperties.getProperty(Constants.MYSQL_JDBC_URL_KEY);
        userName = deploymentProperties.getProperty(Constants.MYSQL_JDBC_USERNAME_KEY);
        password = deploymentProperties.getProperty(Constants.MYSQL_JDBC_PASSWORD_KEY);

        ConfigRegistry registry = ConfigRegistry.getInstance();
        HashMap<String, String> configMap = new HashMap<>(3);
        configMap.put(Constants.MYSQL_JDBC_URL_KEY, jdbcUrl);
        configMap.put(Constants.MYSQL_JDBC_USERNAME_KEY, userName);
        configMap.put(Constants.MYSQL_JDBC_PASSWORD_KEY, password);
        registry.initRegistry(configMap, null, null);

        resourcePath = Paths.get("src", "test", "resources").toAbsolutePath();
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "mysql", "ddl-select-update-test.sql"));
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "mysql", "dml-select-test.sql"));
        selectCompileResult = BCompileUtil
                .compile(Paths.get(resourcePath.toString(), "bal-src", "mysql", "select-test.bal").toString());
        setupDateTimeData();
    }

    @Test(description = "Test numeric type selection query.")
    public void testSelectNumericTypes() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectNumericTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[0];
        Assert.assertTrue(((BBoolean) numericTypeRecord.get(Constants.BIT_VAL_FIELD)).booleanValue(),
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BIT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.TINYINT_VAL_FIELD), 126,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.TINYINT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.SMALLINT_VAL_FIELD), 32765,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.SMALLINT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.MEDIUMINT_VAL_FIELD), 8388603,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.MEDIUMINT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.INT_VAL_FIELD), 2147483644,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.INT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.BIGINT_VAL_FIELD), 2147483649L,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BIGINT_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(numericTypeRecord, Constants.DECIMAL_VAL_FIELD).floatValue(), 143.78f,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.DECIMAL_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(numericTypeRecord, Constants.NUMERIC_VAL_FIELD).floatValue(),
                1034.789f, AssertionUtil.getIncorrectColumnValueMessage(Constants.NUMERIC_VAL_FIELD));
    }

    @Test(description = "Test nil numeric type selection query.")
    public void testSelectNumericTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectNumericTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[0];
        AssertionUtil.assertNullValues(numericTypeRecord, 9, "id");
    }

    @Test(description = "Test float type selection query.")
    public void testSelectFloatTypes() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectFloatTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap floatTypeRecord = (BMap) returns[0];
        Assert.assertEquals(getFloatValFromBMap(floatTypeRecord, Constants.FLOAT_VAL_FIELD), 999.12569, 0.001,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.FLOAT_VAL_FIELD));
        Assert.assertEquals(getFloatValFromBMap(floatTypeRecord, Constants.DOUBLE_VAL_FIELD), 109999.1234123789145,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.DOUBLE_VAL_FIELD));
    }

    @Test(description = "Test nil float type selection query.")
    public void testSelectFloatTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectFloatTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap floatTypeRecord = (BMap) returns[0];
        AssertionUtil.assertNullValues(floatTypeRecord, 3, "id");
    }

    @Test(description = "Test string type selection query.")
    public void testSelectStringTypes() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectStringTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap stringTypeRecord = (BMap) returns[0];
        String[] fieldValues = {
                "Char Column", "Varchar column", "TinyText column", "Text column", "MediumText column",
                "LongText column", "A", "X"
        };
        AssertionUtil.assertNonNullStringValues(stringTypeRecord, 9, fieldValues, "id");
    }

    @Test(description = "Test nil string type selection query.")
    public void testSelectStringTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectStringTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap stringTypeRecord = (BMap) returns[0];
        AssertionUtil.assertNullValues(stringTypeRecord, 9, "id", "setVal", "enumVal");
    }

    @Test(description = "Test date time type selection query")
    public void testDateTimeTypesString() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testDateTimeTypesString");
        Assert.assertTrue(returns[0] instanceof BMap);
        AssertionUtil.assertDateStringValues((BMap) returns[0], date, time, datetime, timestamp);
    }

    // TODO: Add year
    @Test(description = "Test date time type selection query")
    public void testDateTimeTypesInt() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testDateTimeTypesInt");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap dateTimeTypeRecord = (BMap) returns[0];

        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.YEAR, 2019);
        cal.set(Calendar.MONTH, 1);
        cal.set(Calendar.DATE, 1);
        long[] dateTimeExpectedValues = { date, time, datetime, timestamp };
        String[] fields = {
                Constants.DATE_VAL_FIELD_INT, Constants.TIME_VAL_FIELD_INT, Constants.DATETIME_VAL_FIELD_INT,
                Constants.TIMESTAMP_VAL_FIELD_INT
        };
        for (int i = 0; i < fields.length; i++) {
            Assert.assertEquals(((BInteger) dateTimeTypeRecord.get(fields[i])).intValue(), dateTimeExpectedValues[i],
                    AssertionUtil.getIncorrectColumnValueMessage(fields[i]));

        }
    }

    @Test(description = "Test nil date time type selection query")
    public void testDateTimeTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testDateTimeTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        AssertionUtil.assertNullValues((BMap) returns[0], 5);
    }

    // TODO: Add year
    @Test(description = "Test date time type selection query")
    public void testDateTimeTypesRecord() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testDateTimeTypesRecord");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap dateTimeTypeRecord = (BMap) returns[0];
        long[] dateTimeExpectedValues = { dateRec, timeRec, datetimeRec, timestampRec };
        String[] fields = {
                Constants.DATE_VAL_FIELD_REC, Constants.TIME_VAL_FIELD_REC, Constants.DATETIME_VAL_FIELD_REC,
                Constants.TIMESTAMP_VAL_FIELD_REC
        };
        for (int i = 0; i < fields.length; i++) {
            Assert.assertEquals(((BInteger) ((BMap) dateTimeTypeRecord.get(fields[i])).get("time")).intValue(),
                    dateTimeExpectedValues[i], AssertionUtil.getIncorrectColumnValueMessage(fields[i]));
        }
    }

    @Test(description = "Test complex type selection query")
    public void testComplexTypes() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testComplexTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap complexTypeRecord = (BMap) returns[0];
        String[] expectedValues = {
                "Binary Column", "varbinary Column", "TinyBlob Column", "Blob Column", "MediumBlob Column",
                "LongBlob Column"
        };
        String[] fields = {
                Constants.BINARY_FIELD, Constants.VARBINARY_FIELD, Constants.TINYBLOB_FIELD, Constants.BLOB_FIELD,
                Constants.MEDIUMBLOB_FIELD, Constants.LONGBLOB_FIELD
        };

        int i = 0;
        for (String field : fields) {
            String actualValue = (new String(((BValueArray) (complexTypeRecord.get(field))).getBytes()).trim());
            if (field.equals(Constants.BINARY_FIELD)) {
                // When BINARY values are stored, they are right-padded with the pad value to the specified length.
                // The pad value is 0x00 (the zero byte). Values are right-padded with 0x00 on insert, and no
                // trailing bytes are removed on select.
                actualValue = actualValue.trim();
            }
            Assert.assertEquals(actualValue,
                    expectedValues[i], AssertionUtil.getIncorrectColumnValueMessage(field));
            i++;
        }
    }

    @Test(description = "Test nil complex type selection query")
    public void testComplexTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testComplexTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        AssertionUtil.assertNullValues((BMap) returns[0], 7, "id");
    }

    @AfterClass(alwaysRun = true)
    public void cleanup() throws Exception {
        BRunUtil.invoke(selectCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "mysql", "dml-select-test-cleanup.sql"));
    }

    private void setupDateTimeData() {
        BValue[] args = new BValue[4];
        Calendar cal = Calendar.getInstance();

        cal.clear();
        cal.set(Calendar.YEAR, 2017);
        cal.set(Calendar.MONTH, 5);
        cal.set(Calendar.DAY_OF_MONTH, 23);
        date = cal.getTimeInMillis();
        args[0] = new BInteger(date);

        cal.clear();
        cal.set(Calendar.HOUR, 14);
        cal.set(Calendar.MINUTE, 15);
        cal.set(Calendar.SECOND, 23);
        time = cal.getTimeInMillis();
        args[1] = new BInteger(time);

        cal.clear();
        cal.set(Calendar.HOUR, 16);
        cal.set(Calendar.MINUTE, 33);
        cal.set(Calendar.SECOND, 55);
        cal.set(Calendar.YEAR, 2017);
        cal.set(Calendar.MONTH, 1);
        cal.set(Calendar.DAY_OF_MONTH, 25);
        datetime = cal.getTimeInMillis();
        args[2] = new BInteger(datetime);

        cal.clear();
        cal.set(Calendar.HOUR, 02);
        cal.set(Calendar.MINUTE, 33);
        cal.set(Calendar.SECOND, 55);
        cal.set(Calendar.YEAR, 1970);
        cal.set(Calendar.MONTH, 1);
        cal.set(Calendar.DAY_OF_MONTH, 25);
        timestamp = cal.getTimeInMillis();
        args[3] = new BInteger(timestamp);

        BRunUtil.invoke(selectCompileResult, "setUpDatetimeData", args);

        BValue[] returns = BRunUtil.invoke(selectCompileResult, "setupDatetimeRecordData");
        dateRec = ((BInteger) returns[0]).intValue();
        timeRec = ((BInteger) returns[1]).intValue();
        datetimeRec = ((BInteger) returns[2]).intValue();
        timestampRec = ((BInteger) returns[3]).intValue();
    }

    private long getIntValFromBMap(BMap bMap, String key) {
        return ((BInteger) bMap.get(key)).intValue();
    }

    private Double getFloatValFromBMap(BMap bMap, String key) {
        return ((BFloat) bMap.get(key)).floatValue();
    }

    private BigDecimal getDecimalValFromBMap(BMap bMap, String key) {
        return ((BDecimal) bMap.get(key)).decimalValue();
    }
}
