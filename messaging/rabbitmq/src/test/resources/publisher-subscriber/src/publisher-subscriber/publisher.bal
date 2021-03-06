// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/io;
import ballerina/rabbitmq;
import ballerina/http;
import ballerina/kubernetes;

rabbitmq:Connection connection = new({ host: "rabbitmq-broker", port: 5672 });

@kubernetes:Ingress {
    hostname: "rabbitmq.ballerina.io",
    name: "rabbitmq-publisher",
    path: "/"
}

@kubernetes:Service {
    serviceType: "NodePort",
    name: "rabbitmq-publisher"
}

@kubernetes:Deployment {
    image: "rabbitmq.ballerina.io/rabbitmq-publisher:v1.0",
    name: "rabbitmq-publisher",
    username: "<USERNAME>",
    password: "<PASSWORD>",
    push: true,
    imagePullPolicy: "Always"
}

listener http:Listener sendListener = new(8080);

@http:ServiceConfig {
    basePath: "/rabbitmq"
}
service rabbitSend on sendListener {
    @http:ResourceConfig {
        path: "/publisher",
        methods: ["GET"]
    }
    resource function send(http:Caller caller, http:Request request) returns error? {
        rabbitmq:Channel newChannel = new(connection);

        var queueResult1 = newChannel->queueDeclare({ queueName: "MyQueue" });
        if (queueResult1 is error) {
            io:println("An error occurred while creating the MyQueue queue.");
        }
        var sendResult = newChannel->basicPublish("Hello from Ballerina", "MyQueue");
        if (sendResult is error) {
            check caller->respond("An error occurred while sending the message to MyQueue using newChannel.");
        } else {
            check caller->respond("Message sent successfully");
        }
        checkpanic newChannel.close();
        checkpanic connection.close();
    }
}
