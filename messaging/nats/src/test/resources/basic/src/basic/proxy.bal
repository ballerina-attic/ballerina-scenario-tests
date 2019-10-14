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
import ballerina/nats;
import ballerina/kubernetes;
import ballerina/log;
import ballerina/lang.'string as str;

nats:Connection conn = new("nats://example-nats-cluster:4222");
nats:Producer publisher = new(conn);

@kubernetes:Ingress {
    hostname:"ballerina.nats.io",
    name:"proxy-ingress",
    path:"/"
}

@kubernetes:Service {
    serviceType:"NodePort",
    name:"proxy-service"
}

@kubernetes:Deployment {
    image:"<USERNAME>/nats-sender:v1.0",
    name:"proxy-deployment",
    username:"<USERNAME>",
    password:"<PASSWORD>",
    push:true,
    imagePullPolicy:"Always"
}

listener http:Listener sendListener = new(8080);

@http:ServiceConfig {
    basePath: "/proxy"
}
service Proxy on sendListener {
    @http:ResourceConfig {
        path: "/send"
    }
    resource function send(http:Caller caller, http:Request request) returns error? {
        string subject = "demo";

        var result = publisher->request(subject, "Ping!");
        if (result is nats:Error) {
            error e = result;
            log:printError("Error occurred while closing the connection", err = e);
        } else {
            log:printInfo("Response: " + result.toString());
            string|error res = str:fromBytes(result.getData());
            json jsonResult;
            if (res is string) {
                jsonResult = {"Response" : res};
            } else {
                jsonResult = {"Error" : res.reason()};
            }
            var x = caller->respond(jsonResult);
        }
    }

    resource function sayHello(http:Caller caller, http:Request request) {
        json test = {"hello": "world"};
        var x = caller->respond(test);
    }
}
