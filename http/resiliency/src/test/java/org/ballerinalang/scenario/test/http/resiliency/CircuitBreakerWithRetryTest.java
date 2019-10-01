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

package org.ballerinalang.scenario.test.http.resiliency;

import org.ballerinalang.scenario.test.common.ScenarioTestBase;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

@Test(description = "This is a scenario test including circuit breaker and the retry functionalities")
public class CircuitBreakerWithRetryTest extends ScenarioTestBase {

    @BeforeTest(alwaysRun = true)
    public void init() throws Exception {
        super.init();
    }

    @AfterTest(alwaysRun = true)
    public void cleanup() throws Exception {
        super.cleanup();
    }
}
