/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.ballerinalang.scenario.test.messageing.kafka;

import io.netty.handler.codec.http.HttpHeaderNames;
import org.ballerinalang.scenario.test.common.ScenarioTestBase;
import org.ballerinalang.scenario.test.common.http.HttpClientRequest;
import org.ballerinalang.scenario.test.common.http.HttpResponse;
import org.ballerinalang.scenario.test.common.http.TestConstant;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

import static org.awaitility.Awaitility.await;

public class KafkaTest extends ScenarioTestBase {
    private static final String host;
    private static final String producerPort;
    private static final String consumerPort;

    private static final String MESSAGE = "1135";
    private static final String KAFKA_PRODUCER_SUCCESS_MESSAGE = "Message successfully sent to the Kafka service";
    private static final int CONNECTION_TIMEOUT = 10;
    private static final int AWAIT_TIMEOUT = 10;
    private static final int HTTP_OK = 200;

    static {
        Properties deploymentProperties = getDeploymentProperties();
        host = deploymentProperties.getProperty("ExternalIP");
        producerPort = deploymentProperties.getProperty("NodePortProducer");
        consumerPort = deploymentProperties.getProperty("NodePortConsumer");
    }

    @Test
    public void testSendingData() throws IOException {
        String producerHttpServiceUrl = "http://" + host + ":" + producerPort + "/sendMessage";
        String consumerHttpServiceUrl = "http://" + host + ":" + consumerPort + "/sendMessage";

        System.out.println("Producer: " + producerHttpServiceUrl);
        System.out.println("Consumer: " + consumerHttpServiceUrl);

        // Send message to producer HTTP service
        Map<String, String> headers = new HashMap<>();
        headers.put(HttpHeaderNames.CONTENT_TYPE.toString(), TestConstant.CONTENT_TYPE_TEXT_PLAIN);
        HttpResponse producerHttpResponse = HttpClientRequest.doPost(producerHttpServiceUrl, MESSAGE, headers,
                CONNECTION_TIMEOUT);
        await().atMost(AWAIT_TIMEOUT, TimeUnit.SECONDS).until(() -> Objects.nonNull(producerHttpResponse));
        verifyResponse(producerHttpResponse, KAFKA_PRODUCER_SUCCESS_MESSAGE);

        // Retrieve message from consumer HTTP service
        HttpResponse consumerHttpResponse = HttpClientRequest.doGet(consumerHttpServiceUrl, CONNECTION_TIMEOUT);
        await().atMost(AWAIT_TIMEOUT, TimeUnit.SECONDS).until(() -> Objects.nonNull(consumerHttpResponse));
        verifyResponse(consumerHttpResponse, MESSAGE);
    }

    private void verifyResponse(HttpResponse response, String expectedMessage) {
        Assert.assertEquals(response.getResponseCode(), HTTP_OK, response.getData());
        Assert.assertEquals(response.getData(), expectedMessage);
    }
}
