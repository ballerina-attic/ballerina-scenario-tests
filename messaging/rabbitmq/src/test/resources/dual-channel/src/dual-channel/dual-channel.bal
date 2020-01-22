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
import ballerina/runtime;
import ballerina/http;
import ballerina/kubernetes;

rabbitmq:Connection connection = new({ host: "rabbitmq-broker", port: 5672 });

@kubernetes:Ingress {
    hostname: "rabbitmq.ballerina.io",
    name: "rabbitmq-dual-channel",
    path: "/"
}

@kubernetes:Service {
    serviceType: "NodePort",
    name: "rabbitmq-dual-channel"
}

@kubernetes:Deployment {
    image: "rabbitmq.ballerina.io/rabbitmq-dual-channel:v1.0",
    name: "rabbitmq-dual-channel",
    username: "<USERNAME>",
    password: "<PASSWORD>",
    push: true,
    imagePullPolicy: "Always"
}

listener http:Listener sendListener = new(9091);

@http:ServiceConfig {
    basePath: "/rabbitmq"
}
service rabbitSend on sendListener {
    @http:ResourceConfig {
        path: "/dual-channel",
        methods: ["GET"]
    }
    resource function send(http:Caller caller, http:Request request) returns error? {
        string messageVal = "Testing dual channel";
        rabbitmq:Channel newChannel = new(connection);

        var queueResult = newChannel->queueDeclare({ queueName: "MyQueue" });
        if (queueResult is error) {
            io:println("An error occurred while creating the MyQueue queue.");
        }

        var replyToQueueResult = newChannel->queueDeclare({ queueName: "replyQueue" });
        if (queueResult is error) {
            io:println("An error occurred while creating the replyQueue queue.");
        }
        rabbitmq:BasicProperties props = {replyTo: "replyQueue"};
        var sendResult = newChannel->basicPublish(messageVal, "MyQueue", properties = props);
        if (sendResult is error) {
            io:println("An error occurred while sending the message to MyQueue using newChannel.");
            check caller->respond("Message sending failed");
        }
        runtime:sleep(5000);
        var basicGetResult = newChannel->basicGet("replyQueue", rabbitmq:AUTO_ACK);
        if (basicGetResult is rabbitmq:Message) {
            check caller->respond("Dual channel successful.");
        }
        checkpanic connection.close();
    }
}

listener rabbitmq:Listener Listener = new(connection);

@rabbitmq:ServiceConfig {
	queueConfig: {
		queueName: "MyQueue"
	}
}
service consumer on Listener {
    resource function onMessage(rabbitmq:Message message) {
        rabbitmq:Channel newChannel1 = new(connection);
    	rabbitmq:BasicProperties | rabbitmq:Error result = message.getProperties();
    	if (result is rabbitmq:BasicProperties) {
    	    string? replyto = result.replyTo;
    	    if (replyto is string) {
    	        var resultt = newChannel1->basicPublish("Message Received", replyto);
    	    }
    	}
    }
}
