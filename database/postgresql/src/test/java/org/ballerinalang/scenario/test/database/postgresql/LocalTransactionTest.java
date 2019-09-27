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
import org.ballerinalang.model.values.BInteger;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.scenario.test.common.ScenarioTestBase;
import org.ballerinalang.scenario.test.common.database.DatabaseUtil;
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

public class LocalTransactionTest extends ScenarioTestBase {
    private CompileResult localTransactionCompileResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;

    @BeforeClass
    public void setUp() throws Exception {
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
                Paths.get(resourcePath.toString(), "sql-src", "ddl-transaction-test.sql"));
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "dml-transaction-test.sql"));
        localTransactionCompileResult = BCompileUtil
                .compile(Paths.get(resourcePath.toString(), "bal-src", "local-transaction-test.bal").toString());
    }

    @Test
    public void testSelectFullIterateUpdate() {
        BValue[] returns = BRunUtil.invoke(localTransactionCompileResult, "testSelectFullIterateUpdate");
        Assert.assertEquals(((BInteger) returns[0]).intValue(), 0, "Transaction shouldn't have been retried");
        Assert.assertEquals(((BInteger) returns[1]).intValue(), 2, "Iteration count is incorrect");
        Assert.assertEquals(((BInteger) returns[2]).intValue(), 1, "First update should have been successful");
        Assert.assertEquals(((BInteger) returns[3]).intValue(), 1, "Second update should have been successful");
    }

    @Test
    public void testSelectPartialIterateUpdate() {
        BValue[] returns = BRunUtil.invoke(localTransactionCompileResult, "testSelectPartialIterateUpdate");
        Assert.assertEquals(((BInteger) returns[0]).intValue(), 0, "Transaction shouldn't have been retried");
        Assert.assertEquals(((BInteger) returns[1]).intValue(), 1, "Iteration count is incorrect");
        Assert.assertEquals(((BInteger) returns[2]).intValue(), 1, "First update should have been successful");
        Assert.assertEquals(((BInteger) returns[3]).intValue(), 1, "Second update should have been successful");
    }

    @Test
    public void testSelectCloseUpdate() {
        BValue[] returns = BRunUtil.invoke(localTransactionCompileResult, "testSelectCloseUpdate");
        Assert.assertEquals(((BInteger) returns[0]).intValue(), 0, "Transaction shouldn't have been retried");
        Assert.assertEquals(((BInteger) returns[1]).intValue(), 1, "First update should have been successful");
        Assert.assertEquals(((BInteger) returns[2]).intValue(), 1, "Second update should have been successful");
    }

    @Test
    public void testUpdateSelectPartialIterateUpdate() {
        BValue[] returns = BRunUtil.invoke(localTransactionCompileResult, "testUpdateSelectPartialIterateUpdate");
        Assert.assertEquals(((BInteger) returns[0]).intValue(), 0, "Transaction shouldn't have been retried");
        Assert.assertEquals(((BInteger) returns[1]).intValue(), 1, "Iteration count is incorrect");
        Assert.assertEquals(((BInteger) returns[2]).intValue(), 1, "First update should have been successful");
        Assert.assertEquals(((BInteger) returns[3]).intValue(), 1, "Second update should have been successful");
    }

    @Test
    public void testUpdateWithGeneratedKeysSelectFullIterate() {
        BValue[] returns = BRunUtil
                .invoke(localTransactionCompileResult, "testUpdateWithGeneratedKeysSelectFullIterate");
        Assert.assertEquals(((BInteger) returns[0]).intValue(), 0, "Transaction shouldn't have been retried");
        Assert.assertEquals(returns[1].stringValue(), "id1", "Auto generated value is incorrect");
        Assert.assertEquals(((BInteger) returns[2]).intValue(), 1, "First update should have been successful");
        Assert.assertEquals(((BInteger) returns[3]).intValue(), 1, "Second update should have been successful");
    }

    @AfterClass(alwaysRun = true)
    public void cleanup() throws Exception {
        BRunUtil.invoke(localTransactionCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "cleanup-transaction-test.sql"));
    }
}
