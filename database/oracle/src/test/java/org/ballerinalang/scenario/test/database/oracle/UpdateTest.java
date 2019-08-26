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
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.scenario.test.common.ScenarioTestBase;
import org.ballerinalang.scenario.test.common.database.DatabaseUtil;
import org.ballerinalang.scenario.test.database.util.AssertionUtil;
import org.ballerinalang.test.util.BCompileUtil;
import org.ballerinalang.test.util.BRunUtil;
import org.ballerinalang.test.util.CompileResult;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

public class UpdateTest extends ScenarioTestBase {
    private CompileResult updateCompileResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;

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
        updateCompileResult = BCompileUtil
                .compile(Paths.get(resourcePath.toString(), "bal-src", "update-test.bal").toString());
    }

    @Test(description = "Test update integer types with values")
    public void testUpdateIntegerTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateIntegerTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test update integer types with params")
    public void testUpdateIntegerTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateIntegerTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test update floating point types with values")
    public void testUpdateFloatingPointTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFloatingPointTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test update floating point types with params")
    public void testUpdateFloatingPointTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFloatingPointTypesWithParams");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test update fixed point types with values")
    public void testUpdateFixedPointTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFixedPointTypesWithValues");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 1);
    }

    @Test(description = "Test update fixed point types with params")
    public void testUpdateFixedPointTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateFixedPointTypesWithParams");
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

    @Test(description = "Test update complex types")
    public void testUpdateComplexTypesWithValues() {
        BValue[] returns = BRunUtil.invoke(updateCompileResult, "testUpdateComplexTypesWithValues");
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
        List<String> expectedGeneratedKeys = new ArrayList<>(1);
        expectedGeneratedKeys.add("ROWID");
        AssertionUtil.assertUpdateQueryWithGeneratedKeysReturnValue(returns[0], 1, expectedGeneratedKeys);
    }

    @AfterClass(alwaysRun = true)
    public void cleanup() throws Exception {
        BRunUtil.invoke(updateCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "cleanup-select-update-test.sql"));
    }
}
