/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.ballerinalang.scenario.test.messaging.nats;

import org.ballerinalang.scenario.test.common.ScenarioTestBase;
import org.ballerinalang.scenario.test.common.http.HttpClientRequest;
import org.ballerinalang.scenario.test.common.http.HttpResponse;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.io.IOException;
import java.util.Objects;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

import static org.awaitility.Awaitility.await;

/**
 * Tests basic NATS client.
 */
@Test(groups = "NatsBasicTest")
public class BasicNatsClientTest extends ScenarioTestBase {
    private static String host;
    private static String port;

    static {
        Properties deploymentProperties = getDeploymentProperties();
        host = deploymentProperties.getProperty("ExternalIP");
        port = deploymentProperties.getProperty("NodePort");
    }

    @Test(description = "Test NATS connector request-reply scenario")
    public void testNatsRequestReply() throws IOException {
        String url = "http://" + host + ":" + port + "/proxy/send";
        HttpResponse httpResponse = HttpClientRequest.doGet(url);
        await().atMost(120, TimeUnit.SECONDS).until(() -> Objects.nonNull(httpResponse));
        Assert.assertEquals(httpResponse.getData(), "{\"Response\":\"Pong!\"}");
    }
}
