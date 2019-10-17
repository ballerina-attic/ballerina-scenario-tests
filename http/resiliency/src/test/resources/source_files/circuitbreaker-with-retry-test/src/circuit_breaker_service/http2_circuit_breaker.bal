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

// ****************************************************
//              CIRCUIT BREAKER SERVICE               *
// ****************************************************

http:Client http2BackendClient = new ("http://backend-server-go:10400", {
    circuitBreaker: {
        rollingWindow: {
            requestVolumeThreshold: 1,
            timeWindowInMillis: 20000,
            bucketSizeInMillis: 2000
        },
        resetTimeInMillis: 15000,
        failureThreshold: 0.3,    // If more than 3 requests failed among 10 requests, circuit trips.
        statusCodes: [400, 401, 402, 403, 404, 500, 501, 502, 503]
    },
    timeoutInMillis: 2000,
    httpVersion: "2.0"
});

@kubernetes:Service {
    serviceType: "NodePort",
    name: "http2-circuit-breaker",
    port: 10201,
    targetPort: 10201
}
@kubernetes:Ingress {
    hostname: "cb-with-retry.ballerina.io",
    name: "http2-circuit-breaker",
    path: "/"
}
listener http:Listener http2CircuitBreakerListener = new (10201, {
    httpVersion: "2.0"
});

int count2 = 0;

@kubernetes:Deployment {
    image: "cb-with-retry.ballerina.io/http2-circuit-breaker:v1.0",
    name: "http2-circuit-breaker",
    username: "<USERNAME>",
    password: "<PASSWORD>",
    push: true,
    imagePullPolicy: "Always"
}
@http:ServiceConfig {
    basePath: "/"
}
service CallHttp2BackendService on http2CircuitBreakerListener {
    @http:ResourceConfig {
        methods: ["GET"]
    }
    resource function getResponse(http:Caller caller, http:Request request) {
        count2 += 1;
        http:Response response = new;
        var backendResponse = http2BackendClient->forward("/getResponse", request);
        if (backendResponse is http:ClientError) {
            response.statusCode = 503;
            response.setTextPayload(backendResponse.toString());
        } else {
            response.statusCode = backendResponse.statusCode;
            string responseText = <@untainted string>backendResponse.getTextPayload() +
                        " Circuit breaker request count: " + count2.toString();
            response.setTextPayload(responseText);
        }
        var result = caller->respond(response);
    }
}

