// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/kubernetes;
import ballerina/log;

// ****************************************************
//              CIRCUIT BREAKER SERVICE               *
// ****************************************************

http:RollingWindow rollingWindowConfig = {
    requestVolumeThreshold: 1,
    timeWindowInMillis: 20000,
    bucketSizeInMillis: 2000
};

http:CircuitBreakerConfig circuitBreakerConfig = {
    rollingWindow: rollingWindowConfig,
    resetTimeInMillis: 15000,
    failureThreshold: 0.3,    // If more than 3 requests failed among 10 requests, circuit trips.
    statusCodes: [400, 401, 402, 403, 404, 500, 501, 502, 503]
};

http:ClientConfiguration clientConfig = {
    circuitBreaker: circuitBreakerConfig,
    timeoutInMillis: 2000
};

http:Client backendClient = new ("http://http1-backend:10100", clientConfig);

@kubernetes:Service {
    serviceType: "NodePort",
    name: "http1-circuit-breaker",
    port: 10101,
    targetPort: 10101
}
@kubernetes:Ingress {
    hostname: "cb-with-retry.ballerina.io",
    name: "http1-circuit-breaker",
    path: "/"
}
listener http:Listener circuitBreakerListener = new (10101);

string servicePrefix = "[Http1CircuitBreakerService] ";

int count = 0;

@kubernetes:Deployment {
    image: "cb-with-retry.ballerina.io/http1-circuit-breaker:v1.0",
    name: "http1-circuit-breaker",
    username: "<USERNAME>",
    password: "<PASSWORD>",
    push: true,
    imagePullPolicy: "Always"
}
@http:ServiceConfig {
    basePath: "/"
}
service CallBackendService on circuitBreakerListener {
    @http:ResourceConfig {
        methods: ["GET"]
    }
    resource function getResponse(http:Caller caller, http:Request request) {
        count += 1;
        http:Response response = new;
        var backendResponse = backendClient->forward("/getResponse", request);
        if (backendResponse is http:ClientError) {
            response.statusCode = 503;
            response.setTextPayload(backendResponse.toString());
        } else {
            response.statusCode = backendResponse.statusCode;
            string responseText = <@untainted string>backendResponse.getTextPayload() +
            " Circuit breaker request count: " + count.toString();
            response.setTextPayload(responseText);
        }
        var result = caller->respond(response);
        handleResult(result);
    }
}

public function handleResult(error? result) {
    if (result is error) {
        log:printError(servicePrefix + "Error occurred while sending the response", result);
    }
}
