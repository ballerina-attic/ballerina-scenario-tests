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
//                RETRY CLIENT SERVICE                *
// ****************************************************

http:Client backendClientEP = new ("http://http1-circuit-breaker:10101", {
    retryConfig: {
        intervalInMillis: 3000,
        count: 10,
        backOffFactor: 2.0,
        maxWaitIntervalInMillis: 20000,
        statusCodes: [400, 401, 402, 403, 404, 500, 501, 502, 503]
    },
    timeoutInMillis: 2000
});

@kubernetes:Service {
    serviceType: "NodePort",
    name: "http1-retry",
    port: 10102,
    targetPort: 10102
}
@kubernetes:Ingress {
    hostname: "cb-with-retry.ballerina.io",
    name: "http1-retry",
    path: "/"
}
listener http:Listener retryListener = new (10102);

string servicePrefix = "[RetryService] ";
int count = 0;

@kubernetes:Deployment {
    image: "cb-with-retry.ballerina.io/http1-retry:v1.0",
    name: "http1-retry",
    username: "<USERNAME>",
    password: "<PASSWORD>",
    push: true,
    imagePullPolicy: "Always"
}
@http:ServiceConfig {
    basePath: "/"
}
service RetryService on retryListener {
    @http:ResourceConfig {
        methods: ["GET"]
    }
    resource function getResponse(http:Caller caller, http:Request request) {
        count += 1;
        log:printInfo(servicePrefix + "Request Received. Request Count: " + count.toString());
        var backendResponse = backendClientEP->forward("/getResponse", request);
        http:Response response = new;
        if (backendResponse is http:ClientError) {
            response.statusCode = 501;
            response.setTextPayload(<@untainted string>backendResponse.toString() + " Retry request count: " +
                                   count.toString());
        } else {
            string backendResponsePayload = <@untainted string>backendResponse.getTextPayload();
            response.setTextPayload(backendResponsePayload + " Retry request count: " + count.toString());
        }
        var sendResult = caller->respond(response);
        handleResult(sendResult);
    }
}

public function handleResult(error? result) {
    if (result is error) {
        log:printError(servicePrefix + "Error occurred while sending the response", result);
    }
}
