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
import ballerina/log;
import ballerina/rabbitmq;
import ballerina/runtime;
import ballerina/http;
import ballerina/kubernetes;

rabbitmq:Connection connection = new({ host: "rabbitmq-broker", port: 5672 });
string messages = "";

@kubernetes:Ingress {
    hostname: "rabbitmq.ballerina.io",
    name: "rabbitmq-fanout",
    path: "/"
}

@kubernetes:Service {
    serviceType: "NodePort",
    name: "rabbitmq-fanout"
}

@kubernetes:Deployment {
    image: "rabbitmq.ballerina.io/rabbitmq-fanout:v1.0",
    name: "rabbitmq-fanout",
    username: "<USERNAME>",
    password: "<PASSWORD>",
    push: true,
    imagePullPolicy: "Always"
}

listener http:Listener sendListener = new(9095);

@http:ServiceConfig {
    basePath: "/rabbitmq"
}
service rabbitSend on sendListener {
    @http:ResourceConfig {
        path: "/fanout",
        methods: ["GET"]
    }
    resource function send(http:Caller caller, http:Request request) returns error? {
        rabbitmq:Channel newChannel = new(connection);

        var exchangeResult = newChannel->exchangeDeclare({ exchangeName: "fanout-exchange", exchangeType: rabbitmq:FANOUT_EXCHANGE});
        var queueResult1 = newChannel->queueDeclare({ queueName: "MyQueue1"});
        var queueResult2 = newChannel->queueDeclare({ queueName: "MyQueue2"});
        var queueResult3 = newChannel->queueDeclare({ queueName: "MyQueue3"});
        var bindingResult1 = newChannel->queueBind("MyQueue1", "fanout-exchange", "MyQueue1");
        var bindingResult2 = newChannel->queueBind("MyQueue2", "fanout-exchange", "MyQueue2");
        var bindingResult3 = newChannel->queueBind("MyQueue3", "fanout-exchange", "MyQueue3");
        var sendResult = newChannel->basicPublish("Hello", "MyQueue1", "fanout-exchange");
        if (sendResult is error) {
            io:println("An error occurred while sending the message to fanout-exchange using newChannel.");
        } else {
            runtime:sleep(5000);
            check caller->respond(messages);
        }
    }
}

listener rabbitmq:Listener channelListener= new(connection);

@rabbitmq:ServiceConfig {
    queueConfig: {
        queueName: "MyQueue1"
    }
}
service rabbitmqSubscriber1 on channelListener {
    resource function onMessage(rabbitmq:Message message, string data) {
        var messageContent = message.getTextContent();
        if (messageContent is string) {
            messages = messages + <@untainted>data;
        } else {
            io:println("Error occurred while retrieving the message content in rabbitmqSubscriber1.");
        }
    }

    // Gets triggered when an error is encountered.
    resource function onError(rabbitmq:Message message, error err) {
        log:printError("Error from connector: " + err.reason() + " - " + <string>err.detail()?.message);
    }
}

@rabbitmq:ServiceConfig {
    queueConfig: {
        queueName: "MyQueue2"
    }
}
service rabbitmqSubscriber2 on channelListener {
    resource function onMessage(rabbitmq:Message message, string data) {
        var messageContent = message.getTextContent();
        if (messageContent is string) {
            messages = messages + <@untainted>data;
        } else {
            io:println("Error occurred while retrieving the message content in rabbitmqSubscriber2.");
        }
    }

    // Gets triggered when an error is encountered.
    resource function onError(rabbitmq:Message message, error err) {
        log:printError("Error from connector: " + err.reason() + " - " + <string>err.detail()?.message);
    }
}

@rabbitmq:ServiceConfig {
    queueConfig: {
        queueName: "MyQueue3"
    }
}
service rabbitmqSubscriber3 on channelListener {
    resource function onMessage(rabbitmq:Message message, string data) {
        var messageContent = message.getTextContent();
        if (messageContent is string) {
            messages = messages + <@untainted>data;
        } else {
            io:println("Error occurred while retrieving the message content in rabbitmqSubscriber3.");
        }
    }

    // Gets triggered when an error is encountered.
    resource function onError(rabbitmq:Message message, error err) {
        log:printError("Error from connector: " + err.reason() + " - " + <string>err.detail()?.message);
    }
}
