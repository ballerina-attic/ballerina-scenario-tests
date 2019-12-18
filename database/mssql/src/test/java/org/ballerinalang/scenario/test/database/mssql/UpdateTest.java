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

import org.ballerinalang.config.ConfigRegistry;
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
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

@Test(groups = Constants.MSSQL_TESTNG_GROUP)
public class UpdateTest extends ScenarioTestBase {
    private CompileResult updateCompileResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;
    private BValue[] args = new BValue[6];

    @BeforeClass
    public void setup() throws Exception {
        Properties deploymentProperties = getDeploymentProperties();
        jdbcUrl = deploymentProperties.getProperty(Constants.MSSQL_JDBC_URL_KEY) + ";databaseName=testdb";
        userName = deploymentProperties.getProperty(Constants.MSSQL_JDBC_USERNAME_KEY);
        password = deploymentProperties.getProperty(Constants.MSSQL_JDBC_PASSWORD_KEY);

        ConfigRegistry registry = ConfigRegistry.getInstance();
        HashMap<String, String> configMap = new HashMap<>(3);
        configMap.put(Constants.MSSQL_JDBC_URL_KEY, jdbcUrl);
        configMap.put(Constants.MSSQL_JDBC_USERNAME_KEY, userName);
        configMap.put(Constants.MSSQL_JDBC_PASSWORD_KEY, password);
        registry.initRegistry(configMap, null, null);

        resourcePath = Paths.get("src", "test", "resources").toAbsolutePath();
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "ddl-select-update-test.sql"));
        updateCompileResult = BCompileUtil
                .compile(Paths.get(resourcePath.toString(), "bal-src", "update-test.bal").toString());
    }

    @Test(description = "Test update Integer types with values")
    public void testUpdateIntegerTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateIntegerTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
        Assert.assertTrue(returns[1] instanceof BMap);
        BMap integerTypeRecord = (BMap) returns[1];
        Assert.assertEquals(getIntValFromBMap(integerTypeRecord, Constants.SMALLINT_VAL_FIELD), 32767,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.SMALLINT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(integerTypeRecord, Constants.BIGINT_VAL_FIELD), 9223372036854775807L,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BIGINT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(integerTypeRecord, Constants.TINYINT_VAL_FIELD), 255,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.TINYINT_VAL_FIELD));
        Assert.assertTrue(((BBoolean) integerTypeRecord.get(Constants.BIT_VAL_FIELD)).booleanValue(),
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BIT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(integerTypeRecord, Constants.INT_VAL_FIELD), 2147483647,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.INT_VAL_FIELD));
    }

    @Test(description = "Test update Integer types with params")
    public void testUpdateIntegerTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateIntegerTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
        Assert.assertTrue(returns[1] instanceof BMap);
        BMap integerTypeRecord = (BMap) returns[1];
        Assert.assertEquals(getIntValFromBMap(integerTypeRecord, Constants.SMALLINT_VAL_FIELD), 32767,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.SMALLINT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(integerTypeRecord, Constants.BIGINT_VAL_FIELD), 9223372036854775807L,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BIGINT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(integerTypeRecord, Constants.TINYINT_VAL_FIELD), 255,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.TINYINT_VAL_FIELD));
        Assert.assertTrue(((BBoolean) integerTypeRecord.get(Constants.BIT_VAL_FIELD)).booleanValue(),
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BIT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(integerTypeRecord, Constants.INT_VAL_FIELD), 2147483647,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.INT_VAL_FIELD));
    }

    @Test(description = "Test update fixed point types with values")
    public void testUpdateFixedPointTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFixedPointTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
        Assert.assertTrue(returns[1] instanceof BMap);
        BMap fixedPointTypeRecord = (BMap) returns[1];
        Assert.assertEquals(getDecimalValFromBMap(fixedPointTypeRecord, Constants.DECIMAL_VAL_FIELD).floatValue(),
                10.05f, AssertionUtil.getIncorrectColumnValueMessage(Constants.DECIMAL_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(fixedPointTypeRecord, Constants.NUMERIC_VAL_FIELD).floatValue(),
                1.051f, AssertionUtil.getIncorrectColumnValueMessage(Constants.NUMERIC_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(fixedPointTypeRecord, Constants.MONEY_VAL_FIELD).floatValue(),
                922337203685477.5807f, AssertionUtil.getIncorrectColumnValueMessage(Constants.MONEY_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(fixedPointTypeRecord, Constants.SMALLMONEY_VAL_FIELD).floatValue(),
                214748.3647f, AssertionUtil.getIncorrectColumnValueMessage(Constants.SMALLMONEY_VAL_FIELD));
    }

    @Test(description = "Test update fixed point types with params")
    public void testUpdateFixedPointTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFixedPointTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
        Assert.assertTrue(returns[1] instanceof BMap);
        BMap fixedPointTypeRecord = (BMap) returns[1];
        Assert.assertEquals(getDecimalValFromBMap(fixedPointTypeRecord, Constants.DECIMAL_VAL_FIELD).floatValue(),
                10.05f, AssertionUtil.getIncorrectColumnValueMessage(Constants.DECIMAL_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(fixedPointTypeRecord, Constants.NUMERIC_VAL_FIELD).floatValue(),
                1.051f, AssertionUtil.getIncorrectColumnValueMessage(Constants.NUMERIC_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(fixedPointTypeRecord, Constants.MONEY_VAL_FIELD).floatValue(),
                922337203685477.5807f, AssertionUtil.getIncorrectColumnValueMessage(Constants.MONEY_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(fixedPointTypeRecord, Constants.SMALLMONEY_VAL_FIELD).floatValue(),
                214748.3647f, AssertionUtil.getIncorrectColumnValueMessage(Constants.SMALLMONEY_VAL_FIELD));
    }

    @Test(description = "Test update float types with values")
    public void testUpdateFloatTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFloatTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
        Assert.assertTrue(returns[1] instanceof BMap);
        BMap floatTypeRecord = (BMap) returns[1];
        Assert.assertEquals(getFloatValFromBMap(floatTypeRecord, Constants.FLOAT_VAL_FIELD), 123.45678f,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.FLOAT_VAL_FIELD));
        Assert.assertEquals(getFloatValFromBMap(floatTypeRecord, Constants.REAL_VAL_FIELD),
                1234.567f, AssertionUtil.getIncorrectColumnValueMessage(Constants.REAL_VAL_FIELD));
    }

    @Test(description = "Test update float types with params")
    public void testUpdateFloatTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFloatTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
        Assert.assertTrue(returns[1] instanceof BMap);
        BMap floatTypeRecord = (BMap) returns[1];
        Assert.assertEquals(getFloatValFromBMap(floatTypeRecord, Constants.FLOAT_VAL_FIELD), 123.45678f,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.FLOAT_VAL_FIELD));
        Assert.assertEquals(getFloatValFromBMap(floatTypeRecord, Constants.REAL_VAL_FIELD),
                1234.567f, AssertionUtil.getIncorrectColumnValueMessage(Constants.REAL_VAL_FIELD));
    }

    @Test(description = "Test update string types with values")
    public void testUpdateStringTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateStringTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
        Assert.assertTrue(returns[1] instanceof BMap);
        BMap stringTypeRecord = (BMap) returns[1];
        String[] fieldValues = {
                "ABCD", "SQL Server VARCHAR", "This is test message", "MS", "0E984725Ac", "Text"
        };
        AssertionUtil.assertNonNullStringValues(stringTypeRecord, 7, fieldValues, "id");
    }

    @Test(description = "Test update string types with params")
    public void testUpdateStringTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateStringTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
        Assert.assertTrue(returns[1] instanceof BMap);
        BMap stringTypeRecord = (BMap) returns[1];
        String[] fieldValues = {
                "ABCD", "SQL Server VARCHAR", "This is test message", "MS", "0E984725Ac", "Text"
        };
        AssertionUtil.assertNonNullStringValues(stringTypeRecord, 7, fieldValues, "id");
    }

    @Test(description = "Test update complex types with params")
    public void testUpdateComplexTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateComplexTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
        Assert.assertTrue(returns[1] instanceof BMap);
        BMap complexTypeRecord = (BMap) returns[1];
        String[] expectedValues = {
                "Binary Column", "varbinary Column", "Blob Column"
        };
        String[] fields = {
                Constants.BINARY_FIELD, Constants.VARBINARY_FIELD, Constants.IMAGE_FIELD
        };

        int i = 0;
        for (String field : fields) {
            String actualValue = (new String(((BValueArray) (complexTypeRecord.get(field))).getBytes()).trim());
            if (field.equals(Constants.BINARY_FIELD)) {
                actualValue = actualValue.trim();
            }
            Assert.assertEquals(actualValue, expectedValues[i], AssertionUtil.getIncorrectColumnValueMessage(field));
            i++;
        }
    }

    @Test(description = "Test update datetime types with params")
    public void testUpdateDateTimeWithValuesParam() {
        long date = MssqlUtils.getDateValue();
        long time = MssqlUtils.getTimeValue();
        long datetime = MssqlUtils.getDateTimeValue();
        long datetime2 = MssqlUtils.getDateTime2Value();
        long smallDatetime = MssqlUtils.getSmallDateTimeValue();
        long dateTimeOffset = MssqlUtils.getDateTimeOffsetValue();

        args[0] = new BInteger(date);
        args[1] = new BInteger(time);
        args[2] = new BInteger(datetime);
        args[3] = new BInteger(datetime2);
        args[4] = new BInteger(smallDatetime);
        args[5] = new BInteger(dateTimeOffset);

        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateDateTimeWithValuesParam", args);
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
        Assert.assertTrue(returns[1] instanceof BMap);
        BMap dateTimeTypeRecord = (BMap) returns[1];
        MssqlUtils.assertDateValues(dateTimeTypeRecord, date, time, datetime, datetime2, smallDatetime, dateTimeOffset);
    }

    @Test(description = "Test Update with generated keys")
    public void testGeneratedKeyOnInsert() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testGeneratedKeyOnInsert");
        Map<String, String> expectedGeneratedKeys = new HashMap<>(1);
        expectedGeneratedKeys.put("GENERATED_KEYS", "1");
        AssertionUtil.assertUpdateQueryWithGeneratedKeysReturnValue(returns[0], 1, expectedGeneratedKeys);
    }

    private long getIntValFromBMap(BMap bMap, String key) {
        return ((BInteger) bMap.get(key)).intValue();
    }

    private float getFloatValFromBMap(BMap bMap, String key) {
        return (float) ((BFloat) bMap.get(key)).floatValue();
    }

    private BigDecimal getDecimalValFromBMap(BMap bMap, String key) {
        return ((BDecimal) bMap.get(key)).decimalValue();
    }

    @AfterClass(alwaysRun = true)
    public void cleanup() throws Exception {
        BRunUtil.invoke(updateCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "cleanup-select-update-test.sql"));
    }
}
