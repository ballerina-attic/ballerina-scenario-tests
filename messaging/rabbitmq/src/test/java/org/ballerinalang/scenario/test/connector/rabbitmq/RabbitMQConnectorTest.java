/*
 * Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package org.ballerinalang.scenario.test.connector.rabbitmq;

import org.ballerinalang.scenario.test.common.ScenarioTestBase;
import org.ballerinalang.scenario.test.common.http.HttpClientRequest;
import org.ballerinalang.scenario.test.common.http.HttpResponse;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

import static org.awaitility.Awaitility.await;

@Test(groups = "RabbitMQConnector")
public class RabbitMQConnectorTest extends ScenarioTestBase {
    private static String host;
    private static String publisherPort;
    private static String competingConsumerPort;
    private static String dualChannelPort;
    private static String pubSubPort;

    static {
        Properties deploymentProperties = getDeploymentProperties();
        host = deploymentProperties.getProperty("ExternalIP");
        publisherPort = deploymentProperties.getProperty("NodePortPublisher");
        competingConsumerPort = deploymentProperties.getProperty("NodePortCompetingConsumer");
        dualChannelPort = deploymentProperties.getProperty("NodePortDualChannel");
        pubSubPort = deploymentProperties.getProperty("NodePortFanout");
    }

    @Test(description = "Test RabbitMQ simple publisher")
    public void testPublisher() throws IOException {
        String url = "http://" + host + ":" + publisherPort + "/rabbitmq/publisher";
        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        HttpResponse httpResponse = HttpClientRequest.doGet(url, headers);
        Assert.assertEquals(httpResponse.getData(), "Message sent successfully");
    }

    // Acknowledgements, QoS settings, basicGet and data-binding are used in this scenario
    @Test(description = "Test competing consumers pattern")
    public void testCompetingConsumer() throws IOException {
        String url = "http://" + host + ":" + competingConsumerPort + "/rabbitmq/competing-consumer";
        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        HttpResponse httpResponse = HttpClientRequest.doGet(url, headers);
        await().atMost(60, TimeUnit.SECONDS).until(() -> Objects.nonNull(httpResponse));
        Assert.assertEquals(httpResponse.getData(), "Hello 0Hello 1Hello 2Hello 3Hello 4Hello 5Hello 6Hello 7Hello 8Hello 9");
    }

    // Negative acknowledgements, replyTo queue, basicGet are used in this scenario
    @Test(description = "Test dual channel scenario with RabbitMQ connector")
    public void testDualChannel() throws IOException {
        String url = "http://" + host + ":" + dualChannelPort + "/rabbitmq/dual-channel";
        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        HttpResponse httpResponse = HttpClientRequest.doGet(url, headers);
        Assert.assertEquals(httpResponse.getData(), "Dual channel successful.");
    }

    // Fanout exchanges are used in this scenario
    @Test(description = "Test Pub/Sub pattern with RabbitMQ connector")
    public void testPubSub() throws IOException {
        String url = "http://" + host + ":" + pubSubPort + "/rabbitmq/fanout";
        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        HttpResponse httpResponse = HttpClientRequest.doGet(url, headers);
        Assert.assertEquals(httpResponse.getData(), "HelloHelloHello");
    }
}
