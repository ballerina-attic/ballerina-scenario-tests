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

@Test(groups = Constants.POSTGRES_TESTNG_GROUP)
public class BatchUpdateTest extends ScenarioTestBase {
    private CompileResult batchUpdateCompileResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;

    @BeforeClass
    public void setup() throws Exception {
        Properties deploymentProperties = getDeploymentProperties();
        jdbcUrl = deploymentProperties.getProperty(org.ballerinalang.scenario.test.database.postgresql.Constants.POSTGRES_JDBC_URL_KEY);
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
                Paths.get(resourcePath.toString(), "sql-src", "ddl-select-update-test.sql"));
        batchUpdateCompileResult = BCompileUtil.compileAndSetup(
                Paths.get(resourcePath.toString(), "bal-src", "batch-update-test.bal").toString());
    }

    @Test(description = "Test update numeric types with params")
    public void testBatchUpdateIntegerTypesWithParams() {
        BValue[] returns = BRunUtil.invokeStateful(batchUpdateCompileResult, "testBatchUpdateIntegerTypesWithParams");
        int[] expectedArrayOfUpdatedRowCount = { 1, 1 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }

    @Test(description = "Test update numeric types with params")
    public void testBatchUpdateFixedPointTypesWithParams() {
        BValue[] returns = BRunUtil.invokeStateful(batchUpdateCompileResult, "testBatchUpdateFixedPointTypesWithParams");
        int[] expectedArrayOfUpdatedRowCount = { 1, 1 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }

    @Test(description = "Test update string types with params")
    public void testBatchUpdateStringTypesWithParams() {
        BValue[] returns = BRunUtil.invokeStateful(batchUpdateCompileResult, "testBatchUpdateStringTypesWithParams");
        int[] expectedArrayOfUpdatedRowCount = { 1, 1 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }

    @Test(description = "Test update complex types with params")
    public void testBatchUpdateComplexTypesWithParams() {
        BValue[] returns = BRunUtil.invokeStateful(batchUpdateCompileResult, "testBatchUpdateComplexTypesWithParams");
        int[] expectedArrayOfUpdatedRowCount = { 1, 1 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }

    @Test(description = "Test update datetime types with params")
    public void testBatchUpdateDateTimeWithValuesParam() {
        BValue[] returns = BRunUtil.invokeStateful(batchUpdateCompileResult, "testBatchUpdateDateTimeWithValuesParam");
        int[] expectedArrayOfUpdatedRowCount = { 1, 1 };
        AssertionUtil.assertBatchUpdateQueryReturnValue(returns[0], expectedArrayOfUpdatedRowCount);
    }

    @AfterClass(alwaysRun = true)
    public void cleanup() throws Exception {
        BRunUtil.invokeStateful(batchUpdateCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "cleanup-select-test.sql"));
    }
}
