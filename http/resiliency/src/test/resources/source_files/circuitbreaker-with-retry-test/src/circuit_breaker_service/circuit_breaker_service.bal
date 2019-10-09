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
//           HTTP/1 CIRCUIT BREAKER SERVICE           *
// ****************************************************

http:Client http1BackendClient = new ("http://http1-backend:10300", {
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
    timeoutInMillis: 2000
});

@kubernetes:Service {
    serviceType: "NodePort",
    name: "http1-circuit-breaker",
    port: 10200,
    targetPort: 10200
}
@kubernetes:Ingress {
    hostname: "http1-cb.cb-with-retry.ballerina.io",
    name: "http1-circuit-breaker",
    path: "/"
}
listener http:Listener circuitBreakerListener = new (10200);

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
service CallHttp1BackendService on circuitBreakerListener {
    @http:ResourceConfig {
        methods: ["GET"]
    }
    resource function getResponse(http:Caller caller, http:Request request) {
        count += 1;
        http:Response response = new;
        var backendResponse = http1BackendClient->forward("/getResponse", request);
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
    }
}

// ****************************************************
//           HTTP/2 CIRCUIT BREAKER SERVICE           *
// ****************************************************

http:Client http2BackendClient = new ("http://http2-backend:10301", {
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
    hostname: "http2-cb.cb-with-retry.ballerina.io",
    name: "http2-circuit-breaker",
    path: "/"
}
listener http:Listener http2CircuitBreakerListener = new (10201, {
    httpVersion: "2.0"
});

int count2 = 0;

@http:ServiceConfig {
    basePath: "/"
}
service CallHttp2BackendService on circuitBreakerListener {
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
