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
import org.ballerinalang.scenario.test.common.http.HttpClientRequest;
import org.ballerinalang.scenario.test.common.http.HttpResponse;
import org.testng.Assert;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import java.io.IOException;
import java.util.Properties;

@Test(description = "This is a scenario test including circuit breaker and the retry functionalities")
public class CircuitBreakerWithRetryTest extends ScenarioTestBase {
    private static final String host;
    private static final String port;

    static {
        Properties deploymentProperties = getDeploymentProperties();
        host = deploymentProperties.getProperty("ExternalIP");
        port = deploymentProperties.getProperty("NodePort");
    }

    @BeforeTest(alwaysRun = true)
    public void init() throws Exception {
        super.init();
    }

    @Test(description = "Circuit breaker with retry test - http1 to http1")
    public void testCircuitBreakerWithRetryHttp1() throws IOException {
        String message = "[Http1Service] OK response. Backend request count: 3 Circuit breaker request count: 5 " +
                "Retry request count: 1";
        String url = "http://" + host + ":" + port + "/getResponse";
        HttpResponse httpResponse = HttpClientRequest.doGet(url);
        verifyResponse(httpResponse, message, 200);
    }

    private void verifyResponse(HttpResponse response, String expectedMessage, int expectedResponseCode) {
        Assert.assertEquals(response.getResponseCode(), expectedResponseCode, "Response code mismatch");
        Assert.assertEquals(response.getData(), expectedMessage);
    }

    @AfterTest(alwaysRun = true)
    public void cleanup() throws Exception {
        super.cleanup();
    }
}
