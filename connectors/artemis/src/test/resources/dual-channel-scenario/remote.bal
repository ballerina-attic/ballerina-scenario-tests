// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
import ballerina/log;
import ballerinax/kubernetes;

@kubernetes:Ingress {
    hostname:"artemis.ballerina.io",
    name:"http-service",
    path:"/"
}

@kubernetes:Service {
    serviceType:"NodePort",
    name:"http-service"
}

@kubernetes:Deployment {
    image:"artemis.ballerina.io/http-service:v1.0",
    name:"http-service",
    username:"<USERNAME>",
    password:"<PASSWORD>",
    push:true,
    imagePullPolicy:"Always"
}

listener http:Listener helloListener = new(9090);
@http:ServiceConfig {
    basePath: "/"
}
service hello on helloListener {

    @http:ResourceConfig {
        path: "/remote",
        methods: ["POST"]
    }
    resource function sayHello(http:Caller caller, http:Request req) {
        json resp = {"hello": "Riyafa"};
        var result = caller->respond(resp);

        if (result is error) {
            log:printError("Error sending response", err = result);
        }
    }
}
