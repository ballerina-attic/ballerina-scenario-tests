/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * you may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.ballerinalang.scenario.test.database.mssql;

import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BValueArray;
import org.testng.Assert;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * Provides utility methods used for test assertion.
 */
public class MssqlUtils {
    private static Calendar cal = Calendar.getInstance();

    public static void assertDateValues(BValueArray datetimeValues, long dateInserted, long timeInserted,
                                        long datetimeInserted, long datetime2Inserted, long smallDatetimeInserted,
                                        long dateTimeOffsetInserted) {
        try {
            DateFormat dfDate = new SimpleDateFormat("yyyy-MM-dd");
            String dateReturned = datetimeValues.getBValue(0).stringValue();
            long dateReturnedEpoch = dfDate.parse(dateReturned).getTime();
            Assert.assertEquals(dateReturnedEpoch, dateInserted);

            DateFormat dfDatetime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
            String timestampReturned = datetimeValues.getBValue(1).stringValue();
            long timestampReturnedEpoch = dfDatetime.parse(timestampReturned).getTime();
            Assert.assertEquals(timestampReturnedEpoch, dateTimeOffsetInserted);

            String datetimeReturned = datetimeValues.getBValue(2).stringValue();
            long datetimeReturnedEpoch = dfDatetime.parse(datetimeReturned).getTime();
            Assert.assertEquals(datetimeReturnedEpoch, datetimeInserted);

            String datetime2Returned = datetimeValues.getBValue(3).stringValue();
            long datetime2ReturnedEpoch = dfDatetime.parse(datetime2Returned).getTime();
            Assert.assertEquals(datetime2ReturnedEpoch, datetime2Inserted);

            DateFormat smallDatetime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            String smallDatetimeReturned = datetimeValues.getBValue(4).stringValue();
            long smallDatetimeReturnedEpoch = smallDatetime.parse(smallDatetimeReturned).getTime();
            Assert.assertEquals(smallDatetimeReturnedEpoch, smallDatetimeInserted);

            DateFormat dfTime = new SimpleDateFormat("HH:mm:ss.SSS");
            String timeReturned = datetimeValues.getBValue(5).stringValue();
            long timeReturnedEpoch = dfTime.parse(timeReturned).getTime();
            Assert.assertEquals(timeReturnedEpoch, timeInserted);

        } catch (ParseException e) {
            Assert.fail("Parsing the returned date/time/timestamp value has failed", e);
        }
    }

    public static void assertDateValues(BMap datetimeRecord, long dateInserted, long timeInserted,
                                        long datetimeInserted, long datetime2Inserted, long smallDatetimeInserted,
                                        long dateTimeOffsetInserted) {
        try {
            DateFormat dfDate = new SimpleDateFormat("yyyy-MM-dd");
            String dateReturned = datetimeRecord.get("dateVal").stringValue();
            long dateReturnedEpoch = dfDate.parse(dateReturned).getTime();
            Assert.assertEquals(dateReturnedEpoch, dateInserted);

            DateFormat dfDatetime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
            String timestampReturned = datetimeRecord.get("dateTimeOffsetVal").stringValue();
            long timestampReturnedEpoch = dfDatetime.parse(timestampReturned).getTime();
            Assert.assertEquals(timestampReturnedEpoch, dateTimeOffsetInserted);

            String datetimeReturned = datetimeRecord.get("dateTimeVal").stringValue();
            long datetimeReturnedEpoch = dfDatetime.parse(datetimeReturned).getTime();
            Assert.assertEquals(datetimeReturnedEpoch, datetimeInserted);

            String datetime2Returned = datetimeRecord.get("dateTime2Val").stringValue();
            long datetime2ReturnedEpoch = dfDatetime.parse(datetime2Returned).getTime();
            Assert.assertEquals(datetime2ReturnedEpoch, datetime2Inserted);

            DateFormat smallDatetime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            String smallDatetimeReturned = datetimeRecord.get("smallDateTimeVal").stringValue();
            long smallDatetimeReturnedEpoch = smallDatetime.parse(smallDatetimeReturned).getTime();
            Assert.assertEquals(smallDatetimeReturnedEpoch, smallDatetimeInserted);

            DateFormat dfTime = new SimpleDateFormat("HH:mm:ss.SSS");
            String timeReturned = datetimeRecord.get("timeVal").stringValue();
            long timeReturnedEpoch = dfTime.parse(timeReturned).getTime();
            Assert.assertEquals(timeReturnedEpoch, timeInserted);

        } catch (ParseException e) {
            Assert.fail("Parsing the returned date/time/timestamp value has failed", e);
        }
    }

    public static long getDateValue() {
        cal.clear();
        cal.set(Calendar.YEAR, 2007);
        cal.set(Calendar.MONTH, 5);
        cal.set(Calendar.DAY_OF_MONTH, 8);
        return cal.getTimeInMillis();
    }

    public static long getTimeValue() {
        cal.clear();
        cal.set(Calendar.HOUR, 12);
        cal.set(Calendar.MINUTE, 35);
        cal.set(Calendar.SECOND, 29);
        cal.set(Calendar.MILLISECOND, 123);
        return cal.getTimeInMillis();
    }

    public static long getDateTimeValue() {
        cal.clear();
        cal.set(Calendar.HOUR, 12);
        cal.set(Calendar.MINUTE, 35);
        cal.set(Calendar.SECOND, 29);
        cal.set(Calendar.MILLISECOND, 450);
        cal.set(Calendar.YEAR, 2007);
        cal.set(Calendar.MONTH, 5);
        cal.set(Calendar.DAY_OF_MONTH, 8);
        return cal.getTimeInMillis();
    }

    public static long getDateTime2Value() {
        cal.clear();
        cal.set(Calendar.HOUR, 12);
        cal.set(Calendar.MINUTE, 35);
        cal.set(Calendar.SECOND, 29);
        cal.set(Calendar.MILLISECOND, 123);
        cal.set(Calendar.YEAR, 2007);
        cal.set(Calendar.MONTH, 5);
        cal.set(Calendar.DAY_OF_MONTH, 8);
        return cal.getTimeInMillis();
    }

    public static long getSmallDateTimeValue() {
        cal.clear();
        cal.set(Calendar.HOUR, 12);
        cal.set(Calendar.MINUTE, 35);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.YEAR, 2007);
        cal.set(Calendar.MONTH, 5);
        cal.set(Calendar.DAY_OF_MONTH, 8);
        return cal.getTimeInMillis();
    }

    public static long getDateTimeOffsetValue() {
        cal.clear();
        cal.set(Calendar.HOUR, 12);
        cal.set(Calendar.MINUTE, 35);
        cal.set(Calendar.SECOND, 29);
        cal.set(Calendar.MILLISECOND, 123);
        cal.set(Calendar.YEAR, 2007);
        cal.set(Calendar.MONTH, 5);
        cal.set(Calendar.DAY_OF_MONTH, 8);
        return cal.getTimeInMillis();
    }
}
