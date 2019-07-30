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
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;

import java.math.BigDecimal;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Properties;

@Test(groups = Constants.MSSQL_TESTNG_GROUP)
public class SelectTest extends ScenarioTestBase {
    private CompileResult selectCompileResult;
    private String testdbJdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;
    private static final String DISABLED = "disabled";

    @BeforeSuite
    public void createDatabase() throws Exception {
        Properties deploymentProperties = getDeploymentProperties();
        String jdbcUrl = deploymentProperties.getProperty(Constants.MSSQL_JDBC_URL_KEY);
        String userName = deploymentProperties.getProperty(Constants.MSSQL_JDBC_USERNAME_KEY);
        String password = deploymentProperties.getProperty(Constants.MSSQL_JDBC_PASSWORD_KEY);
        resourcePath = Paths.get("src", "test", "resources").toAbsolutePath();
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password, Paths.get(resourcePath.toString(),
                "sql-src", "db-init.sql"));
    }

    @BeforeClass
    public void setup() throws Exception {
        Properties deploymentProperties = getDeploymentProperties();
        testdbJdbcUrl = deploymentProperties.getProperty(Constants.MSSQL_JDBC_URL_KEY) + ";databaseName=simpledb";
        userName = deploymentProperties.getProperty(Constants.MSSQL_JDBC_USERNAME_KEY);
        password = deploymentProperties.getProperty(Constants.MSSQL_JDBC_PASSWORD_KEY);

        ConfigRegistry registry = ConfigRegistry.getInstance();
        HashMap<String, String> configMap = new HashMap<>(3);
        configMap.put(Constants.MSSQL_JDBC_URL_KEY, testdbJdbcUrl);
        configMap.put(Constants.MSSQL_JDBC_USERNAME_KEY, userName);
        configMap.put(Constants.MSSQL_JDBC_PASSWORD_KEY, password);
        registry.initRegistry(configMap, null, null);

        resourcePath = Paths.get("src", "test", "resources").toAbsolutePath();
        DatabaseUtil.executeSqlFile(testdbJdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "ddl-select-update-test.sql"));
        DatabaseUtil.executeSqlFile(testdbJdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "dml-select-test.sql"));
        selectCompileResult = BCompileUtil
                .compile(Paths.get(resourcePath.toString(), "bal-src", "select-test.bal").toString());
    }

    @Test(description = "Test numeric type selection query.")
    public void testSelectNumericTypes() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectNumericTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[0];
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.SMALLINT_VAL_FIELD), 32767,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.SMALLINT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.BIGINT_VAL_FIELD), 9223372036854775807L,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BIGINT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.TINYINT_VAL_FIELD), 255,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.TINYINT_VAL_FIELD));
        Assert.assertTrue(((BBoolean) numericTypeRecord.get(Constants.BIT_VAL_FIELD)).booleanValue(),
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BIT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.INT_VAL_FIELD), 2147483647,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.INT_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(numericTypeRecord, Constants.DECIMAL_VAL_FIELD).floatValue(), 10.05f,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.DECIMAL_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(numericTypeRecord, Constants.NUMERIC_VAL_FIELD).floatValue(),
                1.051f, AssertionUtil.getIncorrectColumnValueMessage(Constants.NUMERIC_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(numericTypeRecord, Constants.MONEY_VAL_FIELD).floatValue(),
                922337203685477.5807f,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.MONEY_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(numericTypeRecord, Constants.SMALLMONEY_VAL_FIELD).floatValue(),
                214748.3647f,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.SMALLMONEY_VAL_FIELD));
    }

    @Test(description = "Test nil numeric type selection query.")
    public void testSelectNumericTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectNumericTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[0];
        AssertionUtil.assertNullValues(numericTypeRecord, 10, "id");
    }

    @Test(description = "Test float type selection query.")
    public void testSelectFloatTypes() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectFloatTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap floatTypeRecord = (BMap) returns[0];
        Assert.assertEquals(getFloatValFromBMap(floatTypeRecord, Constants.FLOAT_VAL_FIELD), 123.45678f,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.FLOAT_VAL_FIELD));
        Assert.assertEquals(getFloatValFromBMap(floatTypeRecord, Constants.REAL_VAL_FIELD),
                123456789012345678901234567890f,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.REAL_VAL_FIELD));
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
                "ABCD", "SQL Server VARCHAR", "This is test message", "ああ", "ありがとうございまし", "Text"
        };
        AssertionUtil.assertNonNullStringValues(stringTypeRecord, 7, fieldValues, "id");
    }

    @Test(description = "Test nil string type selection query.")
    public void testSelectStringTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testSelectStringTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap stringTypeRecord = (BMap) returns[0];
        AssertionUtil.assertNullValues(stringTypeRecord, 7, "id");
    }

    @Test(description = "Test complex type selection query")
    public void testComplexTypes() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testComplexTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap complexTypeRecord = (BMap) returns[0];
        String[] expectedValues = {
                "Binary Column", "varbinary Column", "0x89504E470D0A1A0A00000"
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

    @Test(description = "Test nil complex type selection query")
    public void testComplexTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testComplexTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        AssertionUtil.assertNullValues((BMap) returns[0], 4, "id");
    }

    @Test(description = "Test date time type selection query", groups = { DISABLED })
    public void testDateTimeTypes() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testDateTimeTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap dateTimeTypeRecord = (BMap) returns[0];
        String[] fieldValues = {
                "2007-05-08", "2007-05-08 12:35:29.1234567 +12:15", "2007-05-08 12:35:29.123",
                "2007-05-08 12:35:29.1234567", "2007-05-08 12:35:00", "12:35:29.1234567"
        };
        AssertionUtil.assertNonNullStringValues(dateTimeTypeRecord, 7, fieldValues, "id");
    }

    @Test(description = "Test nil date time type selection query", groups = { DISABLED })
    public void testDateTimeTypesNil() {
        BValue[] returns = BRunUtil.invoke(selectCompileResult, "testDateTimeTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        AssertionUtil.assertNullValues((BMap) returns[0], 7, "id");
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
        BRunUtil.invoke(selectCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(testdbJdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "cleanup-select-update-test.sql"));
    }
}
