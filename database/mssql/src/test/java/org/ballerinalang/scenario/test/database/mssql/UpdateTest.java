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
import org.ballerinalang.test.util.BCompileUtil;
import org.ballerinalang.test.util.BRunUtil;
import org.ballerinalang.test.util.CompileResult;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.scenario.test.common.ScenarioTestBase;
import org.ballerinalang.scenario.test.common.database.DatabaseUtil;
import org.ballerinalang.scenario.test.database.util.AssertionUtil;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

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

    @BeforeClass
    public void setup() throws Exception {
        Properties deploymentProperties = getDeploymentProperties();
        jdbcUrl = deploymentProperties.getProperty(Constants.MSSQL_JDBC_URL_KEY) + ";databaseName=simpledb";
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

    @Test(description = "Test update numeric types with values")
    public void testUpdateNumericTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateNumericTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test update numeric types with params")
    public void testUpdateNumericTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateNumericTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test update float types with values")
    public void testUpdateFloatTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFloatTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test update float types with params")
    public void testUpdateFloatTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFloatTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test update string types with values")
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
        expectedGeneratedKeys.put("GENERATED_KEYS", "1");
        AssertionUtil.assertUpdateQueryWithGeneratedKeysReturnValue(returns[0], 1, expectedGeneratedKeys);
    }

    @AfterClass(alwaysRun = true)
    public void cleanup() throws Exception {
        BRunUtil.invoke(updateCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "cleanup-select-update-test.sql"));
    }
}
