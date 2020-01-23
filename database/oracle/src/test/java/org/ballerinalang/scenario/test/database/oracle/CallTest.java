/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * you may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.ballerinalang.scenario.test.database.oracle;

import org.ballerinalang.config.ConfigRegistry;
import org.ballerinalang.model.values.BDecimal;
import org.ballerinalang.model.values.BFloat;
import org.ballerinalang.model.values.BInteger;
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

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Properties;

/**
 * Contains `call` remote function tests.
 */
public class CallTest extends ScenarioTestBase {
    private CompileResult callCompilerResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;

    @BeforeClass(enabled = false)
    public void setup() throws Exception {
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
                Paths.get(resourcePath.toString(), "sql-src", "ddl-call-test.sql"));
        callCompilerResult = BCompileUtil
                .compile(Paths.get(resourcePath.toString(), "bal-src", "call-test.bal").toString());
    }

    @Test(description = "Test Integer type IN params", enabled = false)
    public void testCallInParamIntegerTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInParamIntegerTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
    }

    @Test(description = "Test Integer type OUT params", enabled = false)
    public void testCallOutParamIntegerTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallOutParamIntegerTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray integerValues = (BValueArray) returns[1];
        Assert.assertEquals(((BInteger) integerValues.getRefValue(0)).intValue(), 922337203);
    }

    @Test(description = "Test Integer type INOUT params", enabled = false)
    public void testCallInOutParamIntegerTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInOutParamIntegerTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray integerValues = (BValueArray) returns[1];
        Assert.assertEquals(((BInteger) integerValues.getRefValue(0)).intValue(), 922337203);
    }

    @Test(description = "Test fixed point type IN params", enabled = false)
    public void testCallInParamFixedPointTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInParamFixedPointTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
    }

    @Test(description = "Test fixed point type OUT params", enabled = false)
    public void testCallOutParamFixedPointTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallOutParamFixedPointTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray fixedPointValues = (BValueArray) returns[1];
        Assert.assertEquals(((BDecimal) fixedPointValues.getRefValue(0)).floatValue(), 999.125698);
        Assert.assertEquals(((BDecimal) fixedPointValues.getRefValue(1)).floatValue(), 10912.3412378);
    }

    @Test(description = "Test fixed point type INOUT params", enabled = false)
    public void testCallInOutParamFixedPointTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInOutParamFixedPointTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray fixedPointValues = (BValueArray) returns[1];
                Assert.assertEquals(((BDecimal) fixedPointValues.getRefValue(0)).floatValue(), 999.125698);
        Assert.assertEquals(((BDecimal) fixedPointValues.getRefValue(1)).floatValue(), 10912.3412378);
    }

    @Test(description = "Test Float type IN params", enabled = false)
    public void testCallInParamFloatTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInParamFloatTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
    }

    @Test(description = "Test Float type OUT params", enabled = false)
    public void testCallOutParamFloatTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallOutParamFloatTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray floatValues = (BValueArray) returns[1];
        Assert.assertEquals(((BFloat) floatValues.getRefValue(0)).floatValue(), 123.33999633789062);
        Assert.assertEquals(((BFloat) floatValues.getRefValue(1)).floatValue(), 109999.123412378914545);
    }

    @Test(description = "Test Float type INOUT params", enabled = false)
    public void testCallInOutParamFloatTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInOutParamFloatTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray floatValues = (BValueArray) returns[1];
        Assert.assertEquals(((BFloat) floatValues.getRefValue(0)).floatValue(), 123.33999633789062);
        Assert.assertEquals(((BFloat) floatValues.getRefValue(1)).floatValue(), 109999.123412378914545);
    }

    @Test(description = "Test string type IN params", enabled = false)
    public void testCallInParamStringTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInParamStringTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
    }

    @Test(description = "Test string type OUT params", enabled = false)
    public void testCallOutParamStringTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallOutParamStringTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray stringValues = (BValueArray) returns[1];
        String[] fieldValues = {
                "Char Column", "යූනිකෝඩ් දත්ත", "Varchar column", "යූනිකෝඩ් දත්ත"
        };
        for (int i = 0; i < stringValues.size(); i++) {
            String actualValue = stringValues.getRefValue(i).stringValue();
           if (i == 0 || i == 1) {
                actualValue = actualValue.trim();
            }
            Assert.assertEquals(actualValue, fieldValues[i]);
        }
    }

    @Test(description = "Test string type INOUT params", enabled = false)
    public void testCallInOutParamStringTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInOutParamStringTypes");
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray stringValues = (BValueArray) returns[1];
        String[] fieldValues = {
                "Char Column", "යූනිකෝඩ් දත්ත", "Varchar column", "යූනිකෝඩ් දත්ත"
        };
        for (int i = 0; i < stringValues.size(); i++) {
            Assert.assertEquals(stringValues.getRefValue(i).stringValue(), fieldValues[i]);
        }
    }

    @Test(description = "Test complex type IN params", enabled = false)
    public void testCallInParamComplexTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInParamComplexTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
    }

    @Test(description = "Test complex type OUT params", enabled = false)
    public void testCallOutParamComplexTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallOutParamComplexTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        BValueArray complexTypes = (BValueArray) returns[1];
        String[] expectedValues = {
                "QmxvYiBDb2x1bW4=", "Clob Column", "යූනිකෝඩ් දත්ත"
        };
        for (int i = 0; i < complexTypes.size(); i++) {
            Assert.assertEquals(expectedValues[i], complexTypes.getBValue(i).stringValue());
        }
    }

    @Test(description = "Test complex type INOUT params", enabled = false)
    public void testCallInOutParamComplexTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInOutParamComplexTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        BValueArray complexTypes = (BValueArray) returns[1];
        String[] expectedValues = {
                "QmxvYiBDb2x1bW4=", "Clob Column", "යූනිකෝඩ් දත්ත"
        };
        for (int i = 0; i < complexTypes.size(); i++) {
            Assert.assertEquals(expectedValues[i], complexTypes.getBValue(i).stringValue());
        }
    }

    @AfterClass(alwaysRun = true, enabled = false)
    public void cleanup() throws Exception {
        if (callCompilerResult != null) {
            BRunUtil.invoke(callCompilerResult, "stopDatabaseClient");
        }
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "cleanup-select-update-test.sql"));
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "cleanup-call-test.sql"));
    }
}
