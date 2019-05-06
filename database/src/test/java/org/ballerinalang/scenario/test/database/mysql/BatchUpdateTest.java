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
import org.ballerinalang.launcher.util.BCompileUtil;
import org.ballerinalang.launcher.util.BRunUtil;
import org.ballerinalang.launcher.util.CompileResult;
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
import java.util.Properties;

public class BatchUpdateTest extends ScenarioTestBase {
    private CompileResult batchUpdateCompileResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;

    @BeforeClass
    public void setup() throws Exception {
        Properties deploymentProperties = getDeploymentProperties();
        jdbcUrl = deploymentProperties.getProperty(Constants.MYSQL_JDBC_URL_KEY);
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
                Paths.get(resourcePath.toString(), "sql-src", "mysql", "ddl-select-update-test.sql"));
        batchUpdateCompileResult = BCompileUtil
                .compile(Paths.get(resourcePath.toString(), "bal-src", "mysql", "batch-update-test.bal").toString());
    }

    @Test(description = "Test update numeric types with params")
    public void testBatchUpdateNumericTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(batchUpdateCompileResult, "testBatchUpdateNumericTypesWithParams");
        int[] expectedArrayOfUpdatedRowCount = { 1, 1 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }
    

    @Test(description = "Test update string types with params")
    public void testBatchUpdateStringTypesWithParams() {
        BValue[] returns = BRunUtil.invoke(batchUpdateCompileResult, "testBatchUpdateStringTypesWithParams");
        int[] expectedArrayOfUpdatedRowCount = { 1, 1 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }
    
    @Test(description = "Test update complex types with params")
    public void testBatchUpdateComplexTypesWithParams() {
        BValue[] returns = BRunUtil.invokeFunction(batchUpdateCompileResult, "testBatchUpdateComplexTypesWithParams");
        int[] expectedArrayOfUpdatedRowCount = { 1, 1 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }

    @Test(description = "Test update datetime types with params")
    public void testBatchUpdateDateTimeWithValuesParam() {
        BValue[] returns = BRunUtil.invokeFunction(batchUpdateCompileResult, "testBatchUpdateDateTimeWithValuesParam");
        int[] expectedArrayOfUpdatedRowCount = { 1, 1 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }


    @AfterClass(alwaysRun = true)
    public void cleanup() throws Exception {
        BRunUtil.invoke(batchUpdateCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "mysql", "select-update-test-cleanup.sql"));
    }
    
}
