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

import org.testng.Assert;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

/**
 * Provides utility methods used for test assertion.
 */
public class MssqlUtils {

    public static void assertDateTimeValues(String dateReturned, String dateTimeOffsetReturned, String datetimeReturned,
                                            String datetime2Returned, String smallDatetimeReturned, String timeReturned,
                                            String[] fieldValues) {
        try {
            DateFormat dfDate = new SimpleDateFormat("yyyy-MM-dd");
            long dateReturnedEpoch = dfDate.parse(dateReturned).getTime();
            Assert.assertEquals(dfDate.format(dateReturnedEpoch), fieldValues[0]);

            DateFormat dfDateTimeOffset = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSXXX");
            long datetimeOffsetReturnedEpoch = dfDateTimeOffset.parse(dateTimeOffsetReturned).getTime();
            Assert.assertEquals(dfDateTimeOffset.format(datetimeOffsetReturnedEpoch), fieldValues[1]);

            DateFormat dfDatetime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
            long datetimeReturnedEpoch = dfDatetime.parse(datetimeReturned).getTime();
            Assert.assertEquals(dfDatetime.format(datetimeReturnedEpoch), fieldValues[2]);

            long datetime2ReturnedEpoch = dfDatetime.parse(datetime2Returned).getTime();
            Assert.assertEquals(dfDatetime.format(datetime2ReturnedEpoch), fieldValues[3]);

            DateFormat smallDatetime = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            long smallDatetimeReturnedEpoch = smallDatetime.parse(smallDatetimeReturned).getTime();
            Assert.assertEquals(smallDatetime.format(smallDatetimeReturnedEpoch), fieldValues[4]);

            DateFormat dfTime = new SimpleDateFormat("HH:mm:ss.SSS");
            long timeReturnedEpoch = dfTime.parse(timeReturned).getTime();
            Assert.assertEquals(dfTime.format(timeReturnedEpoch), fieldValues[5]);
        } catch (ParseException e) {
            Assert.fail("Parsing the returned date/time/timestamp value has failed", e);
        }
    }
}
