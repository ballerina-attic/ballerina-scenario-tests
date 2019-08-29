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

package org.ballerinalang.scenario.test.database.postgresql;

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
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

@Test(groups = Constants.POSTGRES_TESTNG_GROUP)
public class UpdateTest extends ScenarioTestBase {
    private CompileResult updateCompileResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;

    @BeforeClass
    public void setup() throws Exception {
        Properties deploymentProperties = getDeploymentProperties();
        jdbcUrl = deploymentProperties.getProperty(Constants.POSTGRES_JDBC_URL_KEY) + "/testdb";
        userName = deploymentProperties.getProperty(Constants.POSTGRES_JDBC_USERNAME_KEY);
        password = deploymentProperties.getProperty(Constants.POSTGRES_JDBC_PASSWORD_KEY);

        ConfigRegistry registry = ConfigRegistry.getInstance();
        HashMap<String, String> configMap = new HashMap<>(3);
        configMap.put(Constants.POSTGRES_JDBC_URL_KEY, jdbcUrl);
        configMap.put(Constants.POSTGRES_JDBC_USERNAME_KEY, userName);
        configMap.put(Constants.POSTGRES_JDBC_PASSWORD_KEY, password);
        registry.initRegistry(configMap, null, null);

        resourcePath = Paths.get("src", "test", "resources").toAbsolutePath();
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "ddl-select-update-test.sql"));
        updateCompileResult = BCompileUtil
                .compile(Paths.get(resourcePath.toString(), "bal-src", "update-test.bal").toString());
    }

    @Test(description = "Test update numeric types with values")
    public void testUpdateIntegerTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateIntegerTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);

        Assert.assertTrue(returns[1] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[1];
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.SMALLINT_VAL_FIELD), 32765,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.SMALLINT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.INT_VAL_FIELD), 8388603,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.INT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.BIGINT_VAL_FIELD), 2147483644,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BIGINT_VAL_FIELD));
    }

    @Test(description = "Test update numeric types with params")
    public void testUpdateIntegerTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateIntegerTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);

        Assert.assertTrue(returns[1] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[1];
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.SMALLINT_VAL_FIELD), 32765,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.SMALLINT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.INT_VAL_FIELD), 8388603,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.INT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.BIGINT_VAL_FIELD), 2147483644,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BIGINT_VAL_FIELD));
    }

    @Test(description = "Test update numeric types with values")
    public void testUpdateFixedPointTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFixedPointTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);

        Assert.assertTrue(returns[1] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[1];
        Assert.assertEquals(getDecimalValFromBMap(numericTypeRecord, Constants.NUMERIC_VAL_FIELD).floatValue(),
                1034.789f, AssertionUtil.getIncorrectColumnValueMessage(Constants.NUMERIC_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(numericTypeRecord, Constants.DECIMAL_VAL_FIELD).floatValue(),
                15678.9845f, AssertionUtil.getIncorrectColumnValueMessage(Constants.DECIMAL_VAL_FIELD));
    }

    @Test(description = "Test update numeric types with values")
    public void testUpdateFixedPointTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFixedPointTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);

        Assert.assertTrue(returns[1] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[1];
        Assert.assertEquals(getDecimalValFromBMap(numericTypeRecord, Constants.NUMERIC_VAL_FIELD).floatValue(),
                1034.789f, AssertionUtil.getIncorrectColumnValueMessage(Constants.NUMERIC_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(numericTypeRecord, Constants.DECIMAL_VAL_FIELD).floatValue(),
                15678.9845f, AssertionUtil.getIncorrectColumnValueMessage(Constants.DECIMAL_VAL_FIELD));
    }

    @Test(description = "Test update floating point types with values")
    public void testUpdateFloatingPointTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFloatingPointTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);

        Assert.assertTrue(returns[1] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[1];
        Assert.assertEquals(getFloatValFromBMap(numericTypeRecord, Constants.REAL_VAL_FIELD).floatValue(),
                999.12569f, AssertionUtil.getIncorrectColumnValueMessage(Constants.REAL_VAL_FIELD));
        Assert.assertEquals(getFloatValFromBMap(numericTypeRecord, Constants.DOUBLE_VAL_FIELD).floatValue(),
                109999.1234123789145f, AssertionUtil.getIncorrectColumnValueMessage(Constants.DOUBLE_VAL_FIELD));
    }

    @Test(description = "Test update floating point types with values")
    public void testUpdateFloatingPointTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFloatingPointTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);

        Assert.assertTrue(returns[1] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[1];
        Assert.assertEquals(getFloatValFromBMap(numericTypeRecord, Constants.REAL_VAL_FIELD).floatValue(),
                999.12569f, AssertionUtil.getIncorrectColumnValueMessage(Constants.REAL_VAL_FIELD));
        Assert.assertEquals(getFloatValFromBMap(numericTypeRecord, Constants.DOUBLE_VAL_FIELD).floatValue(),
                109999.1234123789145f, AssertionUtil.getIncorrectColumnValueMessage(Constants.DOUBLE_VAL_FIELD));
    }

    @Test(description = "Test update string types with params")
    public void testUpdateStringTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateStringTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);

        Assert.assertTrue(returns[1] instanceof BMap);
        BMap stringTypeRecord = (BMap) returns[1];
        String[] fieldValues = { "Varchar column", "Text column" };
        AssertionUtil.assertNonNullStringValues(stringTypeRecord, 3, fieldValues, "id");
    }

    @Test(description = "Test update string types with params")
    public void testUpdateStringTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateStringTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);

        Assert.assertTrue(returns[1] instanceof BMap);
        BMap stringTypeRecord = (BMap) returns[1];
        String[] fieldValues = { "Varchar column", "Text column" };
        AssertionUtil.assertNonNullStringValues(stringTypeRecord, 3, fieldValues, "id");
    }

    @Test(description = "Test update complex types with params")
    public void testUpdateComplexTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateComplexTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);

        Assert.assertTrue(returns[1] instanceof BMap);
        BMap complexTypeRecord = (BMap) returns[1];

        String actualValue = (new String(((BValueArray) (complexTypeRecord.get(Constants.BINARY_FIELD))).getBytes())
                .trim());
        Assert.assertEquals(actualValue, "Binary Column",
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BINARY_FIELD));
    }

    @Test(description = "Test update datetime types with params")
    public void testUpdateDateTimeWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateDateTimeWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test Update with generated keys")
    public void testGeneratedKeyOnInsert() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testGeneratedKeyOnInsert");
        Map<String, String> expectedGeneratedKeys = new HashMap<>(3);
        expectedGeneratedKeys.put("id", "1");
        expectedGeneratedKeys.put("col1", "abc");
        expectedGeneratedKeys.put("col2", "92");
        AssertionUtil.assertUpdateQueryWithGeneratedKeysReturnValue(returns[0], 1, expectedGeneratedKeys);
    }

    @Test(description = "Test Update with generated keys - empty results scenario")
    public void testGeneratedKeyOnInsertEmptyResults() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testGeneratedKeyOnInsertEmptyResults");
        Map<String, String> expectedGeneratedKeys = new HashMap<>(2);
        expectedGeneratedKeys.put("col1", "xyz");
        expectedGeneratedKeys.put("col2", "24");
        AssertionUtil.assertUpdateQueryWithGeneratedKeysReturnValue(returns[0], 1, expectedGeneratedKeys);
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

    @AfterClass(alwaysRun = true)
    public void cleanup() throws Exception {
        BRunUtil.invoke(updateCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "cleanup-select-test.sql"));
    }

}
