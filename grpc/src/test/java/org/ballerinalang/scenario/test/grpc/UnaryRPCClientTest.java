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

package org.ballerinalang.scenario.test.grpc;

import io.netty.handler.codec.http.HttpHeaderNames;
import org.ballerinalang.scenario.test.common.ScenarioTestBase;
import org.ballerinalang.scenario.test.common.http.HttpClientRequest;
import org.ballerinalang.scenario.test.common.http.HttpResponse;
import org.ballerinalang.scenario.test.common.http.TestConstant;
import org.json.JSONObject;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * Unit test for simple App.
 */
public class UnaryRPCClientTest extends ScenarioTestBase {

    private static final String REQUEST_PAYLOAD_STRING = "{\"name\":\"Apple\", \"description\":\"iphone7\", \"price\":699}";
    private static final String SERVICE_CONTEXT_PATH = "v1/product";
    private static final int STATUS_CREATED = 201;
    private static final int STATUS_OK = 200;

    private static String host;
    private static String port;

    static {
        Properties deploymentProperties = getDeploymentProperties();
        host = deploymentProperties.getProperty("ExternalIP");
        port = deploymentProperties.getProperty("NodePort");
    }

    @Test(description = "Test connecting with unsecured unary Go server")
    public void testUnsecuredUnaryConnection() throws IOException {
        Map<String, String> headers = new HashMap<>();
        String url = "http://" + host + ":" + port;
        headers.put(HttpHeaderNames.CONTENT_TYPE.toString(), TestConstant.CONTENT_TYPE_JSON);
        HttpResponse response = HttpClientRequest.doPost(url + "/" + SERVICE_CONTEXT_PATH
                , REQUEST_PAYLOAD_STRING, headers);
        Assert.assertEquals(response.getResponseCode(), STATUS_CREATED, "Response code mismatched");
        Assert.assertTrue(response.getData().endsWith("created successfully."), "Message content mismatched");
        Assert.assertTrue(response.getHeaders().containsKey("location"));

        String locationContext = response.getHeaders().get("location");
        HttpResponse getResponse = HttpClientRequest.doGet(url + "/" + locationContext);
        Assert.assertEquals(getResponse.getResponseCode(), STATUS_OK, "Response code mismatched");
        JSONObject jsonObject = new JSONObject(getResponse.getData());
        Assert.assertEquals(jsonObject.get("name"), "Apple");
        Assert.assertEquals(jsonObject.get("description"), "iphone7");
    }
}
