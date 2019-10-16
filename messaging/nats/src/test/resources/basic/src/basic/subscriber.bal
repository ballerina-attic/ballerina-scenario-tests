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

import ballerina/nats;
import ballerina/kubernetes;
import ballerina/log;

// Initializes a connection.
nats:Connection subscriberConnection = new("nats://example-nats-cluster:4222");

@kubernetes:Deployment {
    image:"<USERNAME>/natstest:latest",
    name: "nats-subscriber-service-deployment",
    username:"<USERNAME>",
    password:"<PASSWORD>",
    push:true,
    imagePullPolicy:"Always"
}
// Initializes the NATS listener.
listener nats:Listener subscription = new(subscriberConnection);

// Binds the consumer to listen to the messages published to the 'demo' subject.
@nats:SubscriptionConfig {
    subject: "demo"
}
service demo on subscription {

    resource function onMessage(nats:Message msg, string data) {
        // Prints the incoming message in the console.
        log:printInfo("Received message : " + data);
        string? replyToHeader = msg.getReplyTo();
        if (replyToHeader is ()) {
            log:printError("Reply to header not available");
        } else {
            //nats:Connection conn = new("nats://example-nats-cluster:4222");
            nats:Producer publisher = new(subscriberConnection);
            var res = publisher->publish(replyToHeader, "Pong!");
            if (res is nats:Error) {
                 log:printError("Error during publishing to replyTo Header", res);
            } else {
                log:printInfo("Publishing to replyTo header is successful");
            }
        }
    }

    resource function onError(nats:Message msg, nats:Error err) {
        log:printError("Error occurred in data binding", err);
    }
}
