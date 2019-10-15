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
import ballerina/runtime;

@kubernetes:Service {
    serviceType: "NodePort",
    name: "http2-backend",
    port: 10301,
    targetPort: 10301
}
@kubernetes:Ingress {
	hostname: "cb-with-retry.ballerina.io",
	name: "http2-backend",
	path: "/"
}
listener http:Listener http2Listener = new (10301, {
    httpVersion: "2.0",
    secureSocket: {
        keyStore: {
            path: "./security/ballerinaKeystore.p12",
            password: "ballerina"
        },
        trustStore: {
            path: "./security/ballerinaTruststore.p12",
            password: "ballerina"
        }
    }
});

@kubernetes:Deployment {
    image: "cb-with-retry.ballerina.io/http2-backend:v1.0",
    name: "http2-backend",
    username: "<USERNAME>",
    password: "<PASSWORD>",
    push: true,
    imagePullPolicy: "Always"
}
@http:ServiceConfig {
    basePath: "/"
}
service Http2Service on http2Listener {
    @http:ResourceConfig {
        methods: ["GET"]
    }
    resource function getResponse(http:Caller caller, http:Request req) {
        count2 += 1;
        http:Response response = new;
        int decider = count2 % 4;
        if (decider == 1) {
            // Imitate delayed response, so that the timeout occurs at the client
            runtime:sleep(5000);
            sendErrorResponse(caller, response, http2ServicePrefix, count2);
        } else if (decider == 2) {
            // Sending "501_INTERNAL_SERVER_ERROR" to imitate server failures
            sendErrorResponse(caller, response, http2ServicePrefix, count2);
        // We need two OK responses to switch back circuit-breaker client to closed-circuit state.
        } else if (decider == 3 || decider == 0) {
            sendNormalResponse(caller, response, http2ServicePrefix, count2);
        }
    }
}
