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

@Test(groups = "PostgresTest")
public class DdlTest extends ScenarioTestBase {
    private CompileResult ddlCompileResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;

    @BeforeClass
    public void setUp() throws Exception {
        Properties deploymentProperties = getDeploymentProperties();
        jdbcUrl = deploymentProperties.getProperty(Constants.POSTGRES_JDBC_URL_KEY);
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
                Paths.get(resourcePath.toString(), "sql-src", "postgresql", "ddl-test.sql"));
        ddlCompileResult = BCompileUtil
                .compileAndSetup(Paths.get(resourcePath.toString(), "bal-src", "postgresql", "ddl-test.bal").toString());
    }

    @Test(description = "Tests table creation DDL query")
    public void testCreateTable() {
        BValue[] returns = BRunUtil.invokeStateful(ddlCompileResult, "testCreateTable");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 0);
    }

    @Test(description = "Tests table dropping DDL query")
    public void testDropTable() {
        BValue[] returns = BRunUtil.invokeStateful(ddlCompileResult, "testDropTable");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 0);
    }

    @Test(description = "Tests table alteration DDL query")
    public void testAlterTable() {
        BValue[] returns = BRunUtil.invokeStateful(ddlCompileResult, "testAlterTable");
        AssertionUtil.assertUpdateQueryReturnValue(returns[0], 0);
    }

    @AfterClass(alwaysRun = true)
    public void cleanup() throws Exception {
        BRunUtil.invokeStateful(ddlCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "postgresql", "cleanup-ddl-test.sql"));
    }
}
