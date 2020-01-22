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
import ballerina/runtime;
import ballerina/rabbitmq;
import ballerina/http;
import ballerina/kubernetes;

rabbitmq:Connection connection = new({ host: "rabbitmq-broker", port: 5672 });
string messages = "";

@kubernetes:Ingress {
    hostname: "rabbitmq.ballerina.io",
    name: "rabbitmq-competing-consumer",
    path: "/"
}

@kubernetes:Service {
    serviceType: "NodePort",
    name: "rabbitmq-competing-consumer"
}

@kubernetes:Deployment {
    image: "rabbitmq.ballerina.io/rabbitmq-competing-consumer:v1.0",
    name: "rabbitmq-competing-consumer",
    username: "<USERNAME>",
    password: "<PASSWORD>",
    push: true,
    imagePullPolicy: "Always"
}

listener http:Listener sendListener = new(9090);

@http:ServiceConfig {
    basePath: "/rabbitmq"
}
service publisher on sendListener {
    @http:ResourceConfig {
        path: "/competing-consumer",
        methods: ["GET"]
    }
    resource function send(http:Caller caller, http:Request request) returns error? {
        rabbitmq:Channel newChannel = new(connection);

        var queueResult1 = newChannel->queueDeclare({ queueName: "MyQueueB" });
        if (queueResult1 is error) {
            io:println("An error occurred while creating the MyQueue queue.");
        }
        int i = 0;
        while (i < 10) {
        var sendResult = newChannel->basicPublish("Hello " + i.toString(), "MyQueueB");
            if (sendResult is error) {
                io:println("An error occurred while sending the message to MyQueue using newChannel");
            }
            i = i + 1;
        }
        runtime:sleep(20000);
        check caller->respond(messages);
        checkpanic connection.close();
    }
}

listener rabbitmq:Listener channelListener= new(connection);

@rabbitmq:ServiceConfig {
    queueConfig: {
        queueName: "MyQueueB"
    },
    ackMode: rabbitmq:CLIENT_ACK,
    prefetchCount: 1
}
service rabbitmqCompetingConsumer1 on channelListener {
    resource function onMessage(rabbitmq:Message message, string data) {
        var messageContent = message.getTextContent();
        if (messageContent is string) {
            var ackResult = message->basicAck();
            if (ackResult is ()) {
                messages = messages + <@untainted>data;
            }
        } else {
            io:println("Error occurred while retrieving the message content in rabbitmqCompetingConsumer1.");
        }
    }

    // Gets triggered when an error is encountered.
    resource function onError(rabbitmq:Message message, error err) {
        log:printError("Error from connector: " + err.reason() + " - " + <string>err.detail()?.message);
    }
}

@rabbitmq:ServiceConfig {
    queueConfig: {
        queueName: "MyQueueB"
    },
    ackMode: rabbitmq:CLIENT_ACK,
    prefetchCount: 1
}
service rabbitmqCompetingConsumer2 on channelListener {
    resource function onMessage(rabbitmq:Message message, string data) {
        var messageContent = message.getTextContent();
        if (messageContent is string) {
           var ackResult = message->basicAck();
           if (ackResult is ()) {
               messages = messages + <@untainted>data;
           }
        } else {
            io:println("Error occurred while retrieving the message content in rabbitmqCompetingConsumer2.");
        }
    }

    // Gets triggered when an error is encountered.
    resource function onError(rabbitmq:Message message, error err) {
        log:printError("Error from connector: " + err.reason() + " - " + <string>err.detail()?.message);
    }
}

@rabbitmq:ServiceConfig {
    queueConfig: {
        queueName: "MyQueueB"
    },
    ackMode: rabbitmq:CLIENT_ACK,
    prefetchCount: 1
}
service rabbitmqCompetingConsumer3 on channelListener {
    resource function onMessage(rabbitmq:Message message, string data) {
        var messageContent = message.getTextContent();
        if (messageContent is string) {
            var ackResult = message->basicAck();
            if (ackResult is ()) {
                messages = messages + <@untainted>data;
            }
        } else {
            io:println("Error occurred while retrieving the message content in rabbitmqCompetingConsumer3.");
        }
    }

    // Gets triggered when an error is encountered.
    resource function onError(rabbitmq:Message message, error err) {
        log:printError("Error from connector: " + err.reason() + " - " + <string>err.detail()?.message);
    }
}
