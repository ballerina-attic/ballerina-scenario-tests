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
import org.ballerinalang.model.values.BByte;
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

@Test(groups = Constants.MSSQL_TESTNG_GROUP)
public class CallTest extends ScenarioTestBase {
    private CompileResult callCompilerResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;

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
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "ddl-call-test.sql"));
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "dml-call-test.sql"));
        callCompilerResult = BCompileUtil
                .compile(Paths.get(resourcePath.toString(), "bal-src", "call-test.bal").toString());
    }

    @Test(description = "Test Integer type IN params")
    public void testCallInParamIntegerTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInParamIntegerTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
    }

    @Test(description = "Test Integer type OUT params")
    public void testCallOutParamIntegerTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallOutParamIntegerTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray integerValues = (BValueArray) returns[1];
        Assert.assertEquals(((BInteger) integerValues.getRefValue(0)).intValue(), 32767);
        Assert.assertEquals(((BInteger) integerValues.getRefValue(1)).intValue(), 9223372036854775807L);
        Assert.assertEquals(((BByte) integerValues.getRefValue(2)).intValue(), 126);
        Assert.assertTrue(((BBoolean) integerValues.getRefValue(3)).booleanValue());
        Assert.assertEquals(((BInteger) integerValues.getRefValue(4)).intValue(), 2147483647);
    }

    @Test(description = "Test Integer type INOUT params")
    public void testCallInOutParamIntegerTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInOutParamIntegerTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray integerValues = (BValueArray) returns[1];
        Assert.assertEquals(((BInteger) integerValues.getRefValue(0)).intValue(), 32767);
        Assert.assertEquals(((BInteger) integerValues.getRefValue(1)).intValue(), 9223372036854775807L);
        Assert.assertEquals(((BByte) integerValues.getRefValue(2)).intValue(), 126);
        Assert.assertTrue(((BBoolean) integerValues.getRefValue(3)).booleanValue());
        Assert.assertEquals(((BInteger) integerValues.getRefValue(4)).intValue(), 2147483647);
    }

    @Test(description = "Test fixed point type IN params")
    public void testCallInParamFixedPointTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInParamFixedPointTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
    }

    @Test(description = "Test fixed point type OUT params")
    public void testCallOutParamFixedPointTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallOutParamFixedPointTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray fixedPointValues = (BValueArray) returns[1];
        Assert.assertEquals(((BDecimal) fixedPointValues.getRefValue(0)).floatValue(), 10.05);
        Assert.assertEquals(((BDecimal) fixedPointValues.getRefValue(1)).floatValue(), 1.051);
        Assert.assertEquals(((BDecimal) fixedPointValues.getRefValue(2)).floatValue(), 922337203685477.5807);
        Assert.assertEquals(((BDecimal) fixedPointValues.getRefValue(3)).floatValue(), 214748.3647);
    }

    @Test(description = "Test fixed point type INOUT params")
    public void testCallInOutParamFixedPointTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInOutParamFixedPointTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray fixedPointValues = (BValueArray) returns[1];
        Assert.assertEquals(((BDecimal) fixedPointValues.getRefValue(0)).floatValue(), 10.05);
        Assert.assertEquals(((BDecimal) fixedPointValues.getRefValue(1)).floatValue(), 1.051);
        Assert.assertEquals(((BDecimal) fixedPointValues.getRefValue(2)).floatValue(), 922337203685477.5807);
        Assert.assertEquals(((BDecimal) fixedPointValues.getRefValue(3)).floatValue(), 214748.3647);
    }

    @Test(description = "Test Float type IN params")
    public void testCallInParamFloatTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInParamFloatTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
    }

    @Test(description = "Test Float type OUT params")
    public void testCallOutParamFloatTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallOutParamFloatTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray floatValues = (BValueArray) returns[1];
        Assert.assertEquals(((BFloat) floatValues.getRefValue(0)).floatValue(), 123.45678D, 0.01);
        Assert.assertEquals(((BFloat) floatValues.getRefValue(1)).floatValue(), 1234.567D, 0.01);
    }

    @Test(description = "Test Float type INOUT params")
    public void testCallInOutParamFloatTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInOutParamFloatTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray floatValues = (BValueArray) returns[1];
        Assert.assertEquals(((BFloat) floatValues.getRefValue(0)).floatValue(), 123.45678D, 0.01);
        Assert.assertEquals(((BFloat) floatValues.getRefValue(1)).floatValue(), 1234.567D, 0.01);
    }

    @Test(description = "Test string type IN params")
    public void testCallInParamStringTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInParamStringTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
    }

    @Test(description = "Test string type OUT params")
    public void testCallOutParamStringTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallOutParamStringTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray stringValues = (BValueArray) returns[1];
        String[] fieldValues = {
                "ABCD", "SQL Server VARCHAR", "This is test message", "MS", "0E984725Ac", "Text"
        };
        for (int i = 0; i < stringValues.size(); i++) {
            Assert.assertEquals(stringValues.getRefValue(i).stringValue(), fieldValues[i]);
        }
    }

    @Test(description = "Test string type INOUT params")
    public void testCallInOutParamStringTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInOutParamStringTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray stringValues = (BValueArray) returns[1];
        String[] fieldValues = {
                "ABCD", "SQL Server VARCHAR", "This is test message", "MS", "0E984725Ac", "Text"
        };
        for (int i = 0; i < stringValues.size(); i++) {
            Assert.assertEquals(stringValues.getRefValue(i).stringValue(), fieldValues[i]);
        }
    }

    @Test(description = "Test date time type In params")
    public void testCallInParamDateTimeValues() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInParamDateTimeValues");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
    }

    @Test(description = "Test complex type IN params")
    public void testCallInParamComplexTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInParamComplexTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
    }

    @Test(description = "Test complex type OUT params")
    public void testCallOutParamComplexTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallOutParamComplexTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        BValueArray complexTypes = (BValueArray) returns[1];
        String[] expectedValues = {
                "Binary Column", "varbinary Column", "Blob Column 2"
        };

        for (int i = 0; i < expectedValues.length; i++) {
            String actualValue = complexTypes.getBValue(i).stringValue();
            if (i == 0) {
                actualValue = actualValue.trim();
            }
            Assert.assertEquals(actualValue, expectedValues[i]);
        }
    }

    @Test(description = "Test complex type INOUT params")
    public void testCallInOutParamComplexTypes() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallInOutParamComplexTypes");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        BValueArray complexTypes = (BValueArray) returns[1];
        String[] expectedValues = {
                "Binary Column", "varbinary Column", "Blob Column 2"
        };

        for (int i = 0; i < expectedValues.length; i++) {
            String actualValue = complexTypes.getBValue(i).stringValue();
            if (i == 0) {
                actualValue = actualValue.trim();
            }
            Assert.assertEquals(actualValue, expectedValues[i]);
        }
    }

    @Test(description = "Test cursor type")
    public void testCallFunctionWithRefcursor() {
        BValue[] returns = BRunUtil.invoke(callCompilerResult, "testCallFunctionWithRefcursor");
        AssertionUtil.assertCallQueryReturnValue(returns[0]);
        Assert.assertTrue(returns[1] instanceof BValueArray, "Invalid type");
        BValueArray stringValues = (BValueArray) returns[1];
        String[] fieldValues = {
                "ABCD", "SQL Server VARCHAR", "MS", "0E984725Ac"
        };
        for (int i = 0; i < stringValues.size(); i++) {
            Assert.assertEquals(stringValues.getRefValue(i).stringValue(), fieldValues[i]);
        }
    }

    @AfterClass(alwaysRun = true)
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
