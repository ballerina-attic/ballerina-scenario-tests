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

import ballerina/artemis;
import ballerina/filepath;
import ballerina/http;
import ballerinax/kubernetes;

artemis:Connection con = new("tcp://artemis-broker:61616");
artemis:Session session = new(con, config = {username: "artemis", password: "simetraehcapa"});

@kubernetes:Ingress {
    hostname:"artemis.ballerina.io",
    name:"artemis-consumer",
    path:"/"
}

@kubernetes:Service {
    serviceType:"NodePort",
    name:"artemis-consumer",
    port: 8888,
    targetPort: 8888
}

@kubernetes:Deployment {
    image:"artemis.ballerina.io/artemis-consumer:v1.0",
    name:"artemis-consumer",
    username:"<USERNAME>",
    password:"<PASSWORD>",
    push:true,
    imagePullPolicy:"Always"
}
listener artemis:Listener consumerListener = new(session);
@artemis:ServiceConfig {
    queueConfig: {
        queueName: "SMSStore"
    }
}
service artemisConsumer on consumerListener {

    resource function onMessage(artemis:Message message) returns error? {
        artemis:MessageConfiguration config = message.getConfig();
        var replyTo = config.replyTo;

        http:Client remoteClient = new("http://http-service:9090");
        var payload = message.getPayload();
        if (payload is string) {
            var response = remoteClient->post("/remote", untaint payload);
            if (response is http:Response) {
                if (replyTo is string) {
                    artemis:Producer forwardProd = new(session, replyTo);
                    var uuid = message.getProperty("UUID");
                    if (uuid is string) {
                        artemis:Message msg = new(session, untaint check response.getJsonPayload(), 
                    config={correlationId: uuid});
                        check forwardProd->send(untaint msg);
                    }
                }

            }
        }
    }
}
