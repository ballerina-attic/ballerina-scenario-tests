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

package org.ballerinalang.scenario.test.database.util;

import org.ballerinalang.model.values.BError;
import org.ballerinalang.model.values.BInteger;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.model.values.BValueArray;
import org.testng.Assert;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Provides utility methods used for test assertion.
 */
public class AssertionUtil {

    public static void assertUpdateQueryReturnValue(BValue returnedVal, int expectedUpdatedRowCount) {
        Assert.assertTrue(returnedVal instanceof BMap, returnedVal instanceof BError ?
                getErrorReturnedAssertionMessage((BError) returnedVal) :
                "Return type invalid");
        Assert.assertEquals(((BInteger) ((BMap) returnedVal).get("updatedRowCount")).intValue(),
                expectedUpdatedRowCount);
    }

    public static void assertUpdateQueryWithGeneratedKeysReturnValue(BValue returnedVal, int expectedUpdatedRowCount,
            Map<String, Long> expectedGeneratedKeys) {
        Assert.assertTrue(returnedVal instanceof BMap, returnedVal instanceof BError ?
                getErrorReturnedAssertionMessage((BError) returnedVal) :
                "Return type invalid");
        Assert.assertEquals(((BInteger) ((BMap) returnedVal).get("updatedRowCount")).intValue(),
                expectedUpdatedRowCount);
        BMap actualGeneratedKeys = (BMap) ((BMap) returnedVal).get("generatedKeys");
        Assert.assertEquals(actualGeneratedKeys.size(), expectedGeneratedKeys.size());
        for (String key : expectedGeneratedKeys.keySet()) {
            Assert.assertTrue(actualGeneratedKeys.getMap().containsKey(key),
                    "Key: " + key + " does not exist in generated keys");
            Assert.assertEquals(Long.valueOf(((BInteger) actualGeneratedKeys.get(key)).intValue()),
                    expectedGeneratedKeys.get(key));
        }
    }

    public static void assertBatchUpdateQueryReturnValue(BValue returnedVal, int[] expectedArrayOfUpdatedRowCount) {
        Assert.assertTrue(returnedVal instanceof BValueArray, returnedVal instanceof BError ?
                getErrorReturnedAssertionMessage((BError) returnedVal) :
                "Return type invalid");
        BValueArray actualArrayOfUpdatedRowCount = (BValueArray) returnedVal;
        Assert.assertEquals(actualArrayOfUpdatedRowCount.size(), expectedArrayOfUpdatedRowCount.length);
        for(int i = 0; i < expectedArrayOfUpdatedRowCount.length; i++) {
            Assert.assertEquals(actualArrayOfUpdatedRowCount.getInt(i), expectedArrayOfUpdatedRowCount[i], "Actual row count of param batch " + (i + 1) + " is incorrect" );
        }
    }

    public static void assertCallQueryReturnValue(BValue returnedVal) {
        Assert.assertNull(returnedVal, returnedVal instanceof BError ?
                getErrorReturnedAssertionMessage((BError) returnedVal) :
                "Return type invalid");
    }

    public static String getIncorrectColumnValueMessage(String column) {
        return column + " column value isn't correct";
    }

    public static void assertNullValues(BMap record, int fieldCount, String... fieldsToSkip) {
        Set<String> fieldsToSkipSet = new HashSet<>(Arrays.asList(fieldsToSkip));
        Assert.assertEquals(record.keys().length, fieldCount, "Field count is different");
        for (Object key : record.keys()) {
            if (fieldsToSkipSet.contains(key)) {
                continue;
            }
            Assert.assertNull(record.get(key), AssertionUtil.getIncorrectColumnValueMessage((String) key));
        }
    }

    public static void assertNonNullStringValues(BMap record, int fieldCount, String[] fieldValues, String... fieldsToSkip) {
        Set<String> fieldsToSkipSet = new HashSet<>(Arrays.asList(fieldsToSkip));
        Assert.assertEquals(record.keys().length, fieldCount, "Field count is different");
        int i = 0;
        for (Object key : record.keys()) {
            if (fieldsToSkipSet.contains(key)) {
                continue;
            }
            Assert.assertEquals(getStringValFromBMap(record, (String) key), fieldValues[i],
                    AssertionUtil.getIncorrectColumnValueMessage((String) key));
            i++;
        }
    }

    public static void assertDateStringValues(BMap datetimeRecord, long dateInserted, long timeInserted,
            long datetimeInserted, long timestampInserted) {
        try {
            DateFormat dfDate = new SimpleDateFormat("yyyy-MM-dd");
            String dateReturned = datetimeRecord.get("dateStr").stringValue();
            long dateReturnedEpoch = dfDate.parse(dateReturned).getTime();
            Assert.assertEquals(dateReturnedEpoch, dateInserted);

            DateFormat dfTime = new SimpleDateFormat("HH:mm:ss.SSS");
            String timeReturned = datetimeRecord.get("timeStr").stringValue();
            long timeReturnedEpoch = dfTime.parse(timeReturned).getTime();
            Assert.assertEquals(timeReturnedEpoch, timeInserted);

            DateFormat dfDatetime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
            String datetimeReturned = datetimeRecord.get("dateTimeStr").stringValue();
            long datetimeReturnedEpoch = dfDatetime.parse(datetimeReturned).getTime();
            Assert.assertEquals(datetimeReturnedEpoch, datetimeInserted);

            String timestampReturned = datetimeRecord.get("timestampStr").stringValue();
            long timestampReturnedEpoch = dfDatetime.parse(timestampReturned).getTime();
            Assert.assertEquals(timestampReturnedEpoch, timestampInserted);
        } catch (ParseException e) {
            Assert.fail("Parsing the returned date/time/timestamp value has failed", e);
        }
    }

    public static void assertDateStringValues(BValueArray datetimeValues, long dateInserted, long timeInserted,
            long datetimeInserted, long timestampInserted) {
        try {
            DateFormat dfDate = new SimpleDateFormat("yyyy-MM-dd");
            String dateReturned = datetimeValues.getBValue(0).stringValue();
            long dateReturnedEpoch = dfDate.parse(dateReturned).getTime();
            Assert.assertEquals(dateReturnedEpoch, dateInserted);

            DateFormat dfTime = new SimpleDateFormat("HH:mm:ss.SSS");
            String timeReturned = datetimeValues.getBValue(1).stringValue();
            long timeReturnedEpoch = dfTime.parse(timeReturned).getTime();
            Assert.assertEquals(timeReturnedEpoch, timeInserted);

            DateFormat dfDatetime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
            String datetimeReturned = datetimeValues.getBValue(2).stringValue();
            long datetimeReturnedEpoch = dfDatetime.parse(datetimeReturned).getTime();
            Assert.assertEquals(datetimeReturnedEpoch, datetimeInserted);

            String timestampReturned = datetimeValues.getBValue(3).stringValue();
            long timestampReturnedEpoch = dfDatetime.parse(timestampReturned).getTime();
            Assert.assertEquals(timestampReturnedEpoch, timestampInserted);
        } catch (ParseException e) {
            Assert.fail("Parsing the returned date/time/timestamp value has failed", e);
        }
    }

    private static String getStringValFromBMap(BMap bMap, String key) {
        return bMap.get(key).stringValue();
    }

    private static String getErrorReturnedAssertionMessage(BError error) {
        return "The returned value is of error type. Error message: " + error.getDetails().stringValue();
    }
}
