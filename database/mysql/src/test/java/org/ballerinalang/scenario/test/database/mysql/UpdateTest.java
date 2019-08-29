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

@Test(groups = Constants.MYSQL_TESTNG_GROUP)
public class UpdateTest extends ScenarioTestBase {
    private CompileResult updateCompileResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;

    @BeforeClass
    public void setup() throws Exception {
        Properties deploymentProperties = getDeploymentProperties();
        jdbcUrl = deploymentProperties.getProperty(Constants.MYSQL_JDBC_URL_KEY) + "/testdb";
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
                Paths.get(resourcePath.toString(), "sql-src", "ddl-select-update-test.sql"));
        updateCompileResult = BCompileUtil
                .compile(Paths.get(resourcePath.toString(), "bal-src", "update-test.bal").toString());
    }

    @Test(description = "Test update numeric types with values")
    public void testUpdateNumericTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateNumericTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);

        Assert.assertTrue(returns[0] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[1];
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

    @Test(description = "Test update numeric types with params")
    public void testUpdateNumericTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateNumericTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test update string types with params")
    public void testUpdateStringTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateStringTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test update string types with params")
    public void testUpdateStringTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateStringTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test update complex types with params")
    public void testUpdateComplexTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateComplexTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);

        Assert.assertTrue(returns[1] instanceof BMap);
        BMap complexTypeRecord = (BMap) returns[1];
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
            String base64Value = new String(((BValueArray) (complexTypeRecord.get(field))).getBytes());
            if (field.equals(Constants.BINARY_FIELD)) {
                base64Value = base64Value.trim();
            }
            String actualValue = new String(base64Value.getBytes());
            Assert.assertEquals(actualValue,
                    expectedValues[i], AssertionUtil.getIncorrectColumnValueMessage(field));
            i++;
        }
    }

    @Test(description = "Test update datetime types with params")
    public void testUpdateDateTimeWithValuesParam() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateDateTimeWithValuesParam");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test Update with generated keys")
    public void testGeneratedKeyOnInsert() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testGeneratedKeyOnInsert");
        Map<String, String> expectedGeneratedKeys = new HashMap<>(1);
        expectedGeneratedKeys.put("GENERATED_KEY", "1");
        AssertionUtil.assertUpdateQueryWithGeneratedKeysReturnValue(returns[0], 1, expectedGeneratedKeys);
    }

    @Test(description = "Test Update with generated keys - empty results scenario")
    public void testGeneratedKeyOnInsertEmptyResults() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testGeneratedKeyOnInsertEmptyResults");
        AssertionUtil.assertUpdateQueryWithGeneratedKeysReturnValue(returns[0], 1, new HashMap<>(0));
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
                Paths.get(resourcePath.toString(), "sql-src", "cleanup-select-update-test.sql"));
    }

}
