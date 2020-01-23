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
package org.ballerinalang.scenario.test.database.oracle;

import org.ballerinalang.config.ConfigRegistry;
import org.ballerinalang.model.values.BDecimal;
import org.ballerinalang.model.values.BFloat;
import org.ballerinalang.model.values.BInteger;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.model.values.BValueArray;
import org.ballerinalang.scenario.test.common.ScenarioTestBase;
import org.ballerinalang.scenario.test.common.database.DatabaseUtil;
import org.ballerinalang.scenario.test.database.util.AssertionUtil;
import org.ballerinalang.test.util.BCompileUtil;
import org.ballerinalang.test.util.BRunUtil;
import org.ballerinalang.test.util.CompileResult;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import java.math.BigDecimal;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Properties;

/**
 * Contains `select` remote function tests.
 */
public class SelectTest extends ScenarioTestBase {
    private CompileResult selectCompileResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;

    private static long date;
    private static long timestamp;
    private static long dateRec;
    private static long timestampRec;

    @BeforeClass
    public void setUp() throws Exception {
        Properties deploymentProperties = getDeploymentProperties();
        jdbcUrl = deploymentProperties.getProperty(Constants.ORACLE_JDBC_URL_KEY);
        userName = deploymentProperties.getProperty(Constants.ORACLE_JDBC_USERNAME_KEY);
        password = deploymentProperties.getProperty(Constants.ORACLE_JDBC_PASSWORD_KEY);

        ConfigRegistry registry = ConfigRegistry.getInstance();
        HashMap<String, String> configMap = new HashMap<>(3);
        configMap.put(Constants.ORACLE_JDBC_URL_KEY, jdbcUrl);
        configMap.put(Constants.ORACLE_JDBC_USERNAME_KEY, userName);
        configMap.put(Constants.ORACLE_JDBC_PASSWORD_KEY, password);
        registry.initRegistry(configMap, null, null);

        resourcePath = Paths.get("src", "test", "resources").toAbsolutePath();
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "ddl-select-update-test.sql"));
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "dml-select-test.sql"));
        selectCompileResult = BCompileUtil
                .compile(Paths.get(resourcePath.toString(), "bal-src", "select-test.bal").toString());
        setupDateTimeData();
    }

    @Test(description = "Test numeric type selection query.")
    public void testSelectIntegerTypes() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectIntegerTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[0];
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.INT_VAL_FIELD), 2147483647,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.INT_VAL_FIELD));
    }

    @Test(description = "Test fixed-point type selection query.")
    public void testSelectFixedPointTypes() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectFixedPointTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[0];
        BigDecimal numericValue = getDecimalValFromBMap(numericTypeRecord, Constants.NUMERIC_VAL_FIELD);
        BigDecimal decimalValue = getDecimalValFromBMap(numericTypeRecord, Constants.DECIMAL_VAL_FIELD);
        Assert.assertEquals(numericValue.compareTo(new BigDecimal("123.12")), 0,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.NUMERIC_VAL_FIELD));
        Assert.assertEquals(decimalValue.compareTo(new BigDecimal("123.12")), 0,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.DECIMAL_VAL_FIELD));
    }

    @Test(description = "Test nil numeric type selection query.")
    public void testSelectIntegerTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectIntegerTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[0];
        AssertionUtil.assertNullValues(numericTypeRecord, 2, "id");
    }

    @Test(description = "Test float type selection query.", enabled = false)
    public void testSelectFloatTypes() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectFloatTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap floatTypeRecord = (BMap) returns[0];
        Assert.assertEquals(getFloatValFromBMap(floatTypeRecord, Constants.BINARY_FLOAT_VAL_FIELD), 999.125698, 0.001,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BINARY_FLOAT_VAL_FIELD));
        Assert.assertEquals(getFloatValFromBMap(floatTypeRecord, Constants.BINARY_DOUBLE_VAL_FIELD),
                109999.123412378914545,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BINARY_DOUBLE_VAL_FIELD));
    }

    @Test(description = "Test nil float type selection query.", enabled = false)
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
        //  Since char/nchar types don't allow storing variable length strings, the string would include empty
        //  characters.
        String[] fieldValues = { "Char column         ", "යූනිකෝඩ් දත්ත       ", "Varchar column", "යූනිකෝඩ් දත්ත" };
        AssertionUtil.assertNonNullStringValues(stringTypeRecord, 5, fieldValues, "id");
    }

    @Test(description = "Test nil string type selection query.")
    public void testSelectStringTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectStringTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap stringTypeRecord = (BMap) returns[0];
        AssertionUtil.assertNullValues(stringTypeRecord, 5, "id");
    }

    @Test(description = "Test date time type selection query", enabled = false)
    public void testDateTimeTypesString() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testDateTimeTypesString");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap dateTimeTypeRecord = (BMap) returns[0];
        assertDateStringValues(dateTimeTypeRecord, date, timestamp);
    }

    @Test(description = "Test date time type selection query", enabled = false)
    public void testDateTimeTypesInt() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testDateTimeTypesInt");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap dateTimeTypeRecord = (BMap) returns[0];

        long[] dateTimeExpectedValues = { date, timestamp };
        String[] fields = {
                Constants.DATE_VAL_FIELD_INT, Constants.TIMESTAMP_VAL_FIELD_INT
        };
        // In Oracle date is also mapped to timestamp type. Therefore a timezone will be associated with
        // each value at retrieval (By our code).

        // At insertion (in setupDatetime function) we are creating a time:Time record and obtain time in milli seconds
        // and insert that value. So if we pass a time zone at time:Time record creation, the integer value would
        // reflect that.
        for (int i = 0; i < fields.length; i++) {
            Assert.assertEquals(((BInteger) dateTimeTypeRecord.get(fields[i])).intValue(), dateTimeExpectedValues[i],
                    AssertionUtil.getIncorrectColumnValueMessage(fields[i]));
        }
    }

    @Test(description = "Test nil date time type selection query")
    public void testDateTimeTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testDateTimeTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        AssertionUtil.assertNullValues((BMap) returns[0], 2);
    }

    @Test(description = "Test date time type selection query", enabled = false)
    public void testDateTimeTypesRecord() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testDateTimeTypesRecord");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap dateTimeTypeRecord = (BMap) returns[0];
        long[] dateTimeExpectedValues = { date, timestamp };
        String[] fields = {
                Constants.DATE_VAL_FIELD_REC, Constants.TIMESTAMP_VAL_FIELD_REC
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

        String actualValue = (new String(((BValueArray) (complexTypeRecord.get(Constants.BLOB_FIELD))).getBytes())
                .trim());
        Assert.assertEquals(actualValue, "Blob Column",
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BLOB_FIELD));
    }

    @Test(description = "Test nil complex type selection query")
    public void testComplexTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testComplexTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        AssertionUtil.assertNullValues((BMap) returns[0], 4, "id");
    }

    @AfterClass(alwaysRun = true)
    public void cleanup() throws Exception {
        BRunUtil.invoke(selectCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "cleanup-select-update-test.sql"));
    }

    private void setupDateTimeData() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "setupDatetimeData");
        date = ((BInteger) returns[0]).intValue();
        timestamp = ((BInteger) returns[1]).intValue();
    }

    private long getIntValFromBMap(BMap bMap, String key) {
        return ((BDecimal) bMap.get(key)).intValue();
    }

    private Double getFloatValFromBMap(BMap bMap, String key) {
        return ((BFloat) bMap.get(key)).floatValue();
    }

    private BigDecimal getDecimalValFromBMap(BMap bMap, String key) {
        return ((BDecimal) bMap.get(key)).decimalValue();
    }

    private static void assertDateStringValues(BMap datetimeRecord, long dateInserted, long timestampInserted) {
        try {
            // If we neglect the time and zone here (i.e. remove 'T'HH:mm:ss.SSS) then actual time instance
            // represented by the string will not be taken into account. This will result in a wrong
            // assertion of the values.
            DateFormat dfDate = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
            String dateReturned = datetimeRecord.get("dateStr").stringValue();
            long dateReturnedEpoch = dfDate.parse(dateReturned).getTime();
            Assert.assertEquals(dateReturnedEpoch, dateInserted);

            DateFormat dfTimestmap = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
            String timestampReturned = datetimeRecord.get("timestampStr").stringValue();
            long timestampReturnedEpoch = dfTimestmap.parse(timestampReturned).getTime();
            Assert.assertEquals(timestampReturnedEpoch, timestampInserted);

        } catch (ParseException e) {
            Assert.fail("Parsing the returned date/time/timestamp value has failed", e);
        }
    }
}
