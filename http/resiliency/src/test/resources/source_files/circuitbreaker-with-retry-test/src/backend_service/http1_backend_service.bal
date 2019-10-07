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

// ****************************************************
//                  BACKEND SERVICE                   *
// ****************************************************

@kubernetes:Service {
    serviceType: "NodePort",
    name: "http1-backend",
    port: 10100,
    targetPort: 10100
}
@kubernetes:Ingress {
	hostname: "cb-with-retry.ballerina.io",
	name: "http1-backend",
	path: "/"
}
listener http:Listener http1Listener= new(10100);

int count = 0;
string servicePrefix = "[Http1Service] ";

@kubernetes:Deployment {
    image:"cb-with-retry.ballerina.io/http1-backend:v1.0",
    name:"http1-backend",
    username:"<USERNAME>",
    password:"<PASSWORD>",
    push:true,
    imagePullPolicy:"Always"
}
@http:ServiceConfig {
    basePath: "/"
}
service Http1Service on http1Listener {
    @http:ResourceConfig {
        methods: ["GET"]
	}
    resource function getResponse(http:Caller caller, http:Request req) {
        count += 1;
        http:Response response = new;
        int decider = count % 4;
        if (decider == 1) {
            // Imitate delayed response, so that the timeout occurs at the client
            runtime:sleep(5000);
            sendErrorResponse(caller, response, servicePrefix);
        } else if (decider == 2) {
            // Sending "501_INTERNAL_SERVER_ERROR" to imitate server failures
            sendErrorResponse(caller, response, servicePrefix);
        // We need two OK responses to switch back circuit-breaker client to closed-circuit state.
        } else if (decider == 3 || decider == 0) {
            sendNormalResponse(caller, response, servicePrefix);
        }
    }
}
