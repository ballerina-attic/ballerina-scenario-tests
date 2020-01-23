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
import java.util.HashMap;
import java.util.Properties;

/**
 * Contains `batchUpdate` remote function tests.
 */
public class BatchUpdateTest extends ScenarioTestBase {
    private CompileResult batchUpdateCompileResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;

    @BeforeClass(enabled = false)
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
        batchUpdateCompileResult = BCompileUtil
                .compile(Paths.get(resourcePath.toString(), "bal-src", "batch-update-test.bal").toString());
    }

    @Test(description = "Test update integer types with params", enabled = false)
    public void testBatchUpdateIntegerTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(batchUpdateCompileResult, "testBatchUpdateIntegerTypesWithParams");
        int[] expectedArrayOfUpdatedRowCount = { -2, -2 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }

    @Test(description = "Test update integer types with params", enabled = false)
    public void testBatchUpdateFixedPointTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(batchUpdateCompileResult, "testBatchUpdateFixedPointTypesWithParams");
        int[] expectedArrayOfUpdatedRowCount = { -2, -2 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }

    @Test(description = "Test update integer types with params", enabled = false)
    public void testUpdateFloatingPointTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(batchUpdateCompileResult, "testBatchUpdateFixedPointTypesWithParams");
        int[] expectedArrayOfUpdatedRowCount = { -2, -2 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }

    @Test(description = "Test update string types with params", enabled = false)
    public void testBatchUpdateStringTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(batchUpdateCompileResult, "testBatchUpdateStringTypesWithParams");
        int[] expectedArrayOfUpdatedRowCount = { -2, -2 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }

    @Test(description = "Test update complex types with params", enabled = false)
    public void testBatchUpdateComplexTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(batchUpdateCompileResult, "testBatchUpdateComplexTypesWithParams");
        int[] expectedArrayOfUpdatedRowCount = { -2, -2 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }

    @Test(description = "Test update datetime types with params", enabled = false)
    public void testBatchUpdateDateTimeWithValuesParam() {
        BValue[] returns = BRunUtil.invoke(batchUpdateCompileResult, "testBatchUpdateDateTimeWithValuesParam");
        int[] expectedArrayOfUpdatedRowCount = { -2, -2 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }

    @AfterClass(alwaysRun = true, enabled = false)
    public void cleanup() throws Exception {
        BRunUtil.invoke(batchUpdateCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "cleanup-select-update-test.sql"));
    }
}
