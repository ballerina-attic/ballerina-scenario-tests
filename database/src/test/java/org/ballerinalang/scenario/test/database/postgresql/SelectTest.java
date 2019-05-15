package org.ballerinalang.scenario.test.database.postgresql;

import org.ballerinalang.config.ConfigRegistry;
import org.ballerinalang.launcher.util.BCompileUtil;
import org.ballerinalang.launcher.util.BRunUtil;
import org.ballerinalang.launcher.util.CompileResult;
import org.ballerinalang.model.values.BDecimal;
import org.ballerinalang.model.values.BFloat;
import org.ballerinalang.model.values.BInteger;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.model.values.BValueArray;
import org.ballerinalang.scenario.test.common.ScenarioTestBase;
import org.ballerinalang.scenario.test.common.database.DatabaseUtil;
import org.ballerinalang.scenario.test.database.util.AssertionUtil;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import java.math.BigDecimal;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Properties;

public class SelectTest extends ScenarioTestBase {
    private CompileResult selectCompileResult;
    private String jdbcUrl;
    private String userName;
    private String password;
    private Path resourcePath;
    private static long date;
    private static long time;
    private static long timez;
    private static long timestamp;
    private static long timestampz;

    @BeforeClass
    public void setup() throws Exception {
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
                Paths.get(resourcePath.toString(), "sql-src", "postgresql", "ddl-select-update-test.sql"));
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "postgresql", "dml-select-test.sql"));
        selectCompileResult = BCompileUtil.compileAndSetup(
                Paths.get(resourcePath.toString(), "bal-src", "postgresql", "select-test.bal").toString());
        setupDateTimeData();
    }

    @Test(description = "Test numeric type selection query.")
    public void testSelectIntegerTypes() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testSelectIntegerTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[0];
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.SMALLINT_VAL_FIELD), 32767,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.SMALLINT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.INT_VAL_FIELD), 2147483646,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.INT_VAL_FIELD));
        Assert.assertEquals(getIntValFromBMap(numericTypeRecord, Constants.BIGINT_VAL_FIELD), 9223372036854775805L,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BIGINT_VAL_FIELD));
    }

    @Test(description = "Test fixed-point type selection query.")
    public void testSelectFixedPointTypes() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testSelectFixedPointTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[0];
        Assert.assertEquals(getDecimalValFromBMap(numericTypeRecord, Constants.NUMERIC_VAL_FIELD).floatValue(),
                12345678.12345f, AssertionUtil.getIncorrectColumnValueMessage(Constants.NUMERIC_VAL_FIELD));
        Assert.assertEquals(getDecimalValFromBMap(numericTypeRecord, Constants.DECIMAL_VAL_FIELD).floatValue(),
                123496789.1234567f, AssertionUtil.getIncorrectColumnValueMessage(Constants.DECIMAL_VAL_FIELD));
    }

    @Test(description = "Test nil numeric type selection query.")
    public void testSelectIntegerTypesNil() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testSelectIntegerTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap numericTypeRecord = (BMap) returns[0];
        AssertionUtil.assertNullValues(numericTypeRecord, 4, "id");
    }

    @Test(description = "Test float type selection query.")
    public void testSelectFloatTypes() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testSelectFloatTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap floatTypeRecord = (BMap) returns[0];
        Assert.assertEquals(getFloatValFromBMap(floatTypeRecord, Constants.REAL_VAL_FIELD), 999.125698, 0.001,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.REAL_VAL_FIELD));
        Assert.assertEquals(getFloatValFromBMap(floatTypeRecord, Constants.DOUBLE_VAL_FIELD), 109999.123412378914545,
                AssertionUtil.getIncorrectColumnValueMessage(Constants.DOUBLE_VAL_FIELD));
    }

    @Test(description = "Test nil float type selection query.")
    public void testSelectFloatTypesNil() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testSelectFloatTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap floatTypeRecord = (BMap) returns[0];
        AssertionUtil.assertNullValues(floatTypeRecord, 3, "id");
    }

    @Test(description = "Test string type selection query.")
    public void testSelectStringTypes() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testSelectStringTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap stringTypeRecord = (BMap) returns[0];
        String[] fieldValues = { "Varchar column", "Text column" };
        AssertionUtil.assertNonNullStringValues(stringTypeRecord, 3, fieldValues, "id");
    }

    @Test(description = "Test nil string type selection query.")
    public void testSelectStringTypesNil() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testSelectStringTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap stringTypeRecord = (BMap) returns[0];
        AssertionUtil.assertNullValues(stringTypeRecord, 3, "id");
    }

    @Test(description = "Test date time type selection query")
    public void testDateTimeTypesString() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testDateTimeTypesString");
        Assert.assertTrue(returns[0] instanceof BMap);
        assertDateStringValues((BMap) returns[0], date, time, timez, timestamp, timestampz);
    }

    @Test(description = "Test date time type selection query")
    public void testDateTimeTypesInt() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testDateTimeTypesInt");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap dateTimeTypeRecord = (BMap) returns[0];

        long[] dateTimeExpectedValues = { date, time, timez, timestamp, timestampz };
        String[] fields = {
                Constants.DATE_VAL_FIELD_INT, Constants.TIME_VAL_FIELD_INT, Constants.TIMEZ_VAL_FIELD_INT,
                Constants.TIMESTAMP_VAL_FIELD_INT, Constants.TIMESTAMPTZ_VAL_FIELD_INT
        };
        for (int i = 0; i < fields.length; i++) {
            Assert.assertEquals(((BInteger) dateTimeTypeRecord.get(fields[i])).intValue(), dateTimeExpectedValues[i],
                    AssertionUtil.getIncorrectColumnValueMessage(fields[i]));
        }
    }

    @Test(description = "Test nil date time type selection query")
    public void testDateTimeTypesNil() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testDateTimeTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        AssertionUtil.assertNullValues((BMap) returns[0], 5);
    }

    @Test(description = "Test date time type selection query")
    public void testDateTimeTypesRecord() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testDateTimeTypesRecord");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap dateTimeTypeRecord = (BMap) returns[0];
        long[] dateTimeExpectedValues = { date, time, timez, timestamp, timestampz };
        String[] fields = {
                Constants.DATE_VAL_FIELD_REC, Constants.TIME_VAL_FIELD_REC, Constants.TIMEZ_VAL_FIELD_REC,
                Constants.TIMESTAMP_VAL_FIELD_REC, Constants.TIMESTAMPZ_VAL_FIELD_REC
        };
        for (int i = 0; i < fields.length; i++) {
            Assert.assertEquals(((BInteger) ((BMap) dateTimeTypeRecord.get(fields[i])).get("time")).intValue(),
                    dateTimeExpectedValues[i], AssertionUtil.getIncorrectColumnValueMessage(fields[i]));
        }
    }

    @Test(description = "Test complex type selection query")
    public void testComplexTypes() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testComplexTypes");
        Assert.assertTrue(returns[0] instanceof BMap);
        BMap complexTypeRecord = (BMap) returns[0];

        String actualValue = (new String(((BValueArray) (complexTypeRecord.get(Constants.BINARY_FIELD))).getBytes())
                .trim());
        Assert.assertEquals(actualValue, "Binary Column",
                AssertionUtil.getIncorrectColumnValueMessage(Constants.BINARY_FIELD));
    }

    @Test(description = "Test nil complex type selection query")
    public void testComplexTypesNil() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "testComplexTypesNil");
        Assert.assertTrue(returns[0] instanceof BMap);
        AssertionUtil.assertNullValues((BMap) returns[0], 2, "id");
    }

    @AfterClass(alwaysRun = true)
    public void cleanup() throws Exception {
        BRunUtil.invokeStateful(selectCompileResult, "stopDatabaseClient");
        DatabaseUtil.executeSqlFile(jdbcUrl, userName, password,
                Paths.get(resourcePath.toString(), "sql-src", "mysql", "cleanup-select-update-test.sql"));
    }

    private void setupDateTimeData() {
        BValue[] returns = BRunUtil.invokeStateful(selectCompileResult, "setupDatetimeData");
        date = ((BInteger) returns[0]).intValue();
        time = ((BInteger) returns[1]).intValue();
        timez = ((BInteger) returns[2]).intValue();
        timestamp = ((BInteger) returns[3]).intValue();
        timestampz = ((BInteger) returns[4]).intValue();
    }

    private long getIntValFromBMap(BMap bMap, String key) {
        return ((BInteger) bMap.get(key)).intValue();
    }

    private Double getFloatValFromBMap(BMap bMap, String key) {
        return ((BFloat) bMap.get(key)).floatValue();
    }

    private BigDecimal getDecimalValFromBMap(BMap bMap, String key) {
        return ((BDecimal) bMap.get(key)).decimalValue();
    }

    public static void assertDateStringValues(BMap datetimeRecord, long dateInserted, long timeInserted,
            long timezInserted, long timestampInserted, long timestampzInserted) {
        try {
            DateFormat dfDate = new SimpleDateFormat("yyyy-MM-dd");
            String dateReturned = datetimeRecord.get("dateStr").stringValue();
            long dateReturnedEpoch = dfDate.parse(dateReturned).getTime();
            Assert.assertEquals(dateReturnedEpoch, dateInserted);

            DateFormat dfTime = new SimpleDateFormat("HH:mm:ss.SSS");
            String timeReturned = datetimeRecord.get("timeStr").stringValue();
            long timeReturnedEpoch = dfTime.parse(timeReturned).getTime();
            Assert.assertEquals(timeReturnedEpoch, timeInserted);

            DateFormat dfTimez = new SimpleDateFormat("HH:mm:ss.SSS");
            String timezReturned = datetimeRecord.get("timezStr").stringValue();
            long timezReturnedEpoch = dfTimez.parse(timezReturned).getTime();
            Assert.assertEquals(timezReturnedEpoch, timezInserted);

            DateFormat dfTimestmap = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
            String timestampReturned = datetimeRecord.get("timestampStr").stringValue();
            long timestampReturnedEpoch = dfTimestmap.parse(timestampReturned).getTime();
            Assert.assertEquals(timestampReturnedEpoch, timestampInserted);

            DateFormat dfTimestmapz = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
            String timestampzReturned = datetimeRecord.get("timestampzStr").stringValue();
            long timestampzReturnedEpoch = dfTimestmapz.parse(timestampzReturned).getTime();
            Assert.assertEquals(timestampzReturnedEpoch, timestampzInserted);

        } catch (ParseException e) {
            Assert.fail("Parsing the returned date/time/timestamp value has failed", e);
        }
    }
}
