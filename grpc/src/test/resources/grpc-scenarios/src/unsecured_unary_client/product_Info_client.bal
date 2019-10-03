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

import ballerina/grpc;
import ballerina/http;
import ballerina/log;

import ballerina/kubernetes;

ProductInfoBlockingClient blockingEp = new("http://localhost:50051");

@kubernetes:Ingress {
    hostname:"<USERNAME>",
    name:"ballerina-grpc-client-proxy",
    path:"/"
}

@kubernetes:Service {
     serviceType:"NodePort",
     name:"ballerina-grpc-client-proxy"
 }

 @kubernetes:Deployment {
     image:"<USERNAME>/ballerina-grpc-client-proxy:v1.0",
     name:"ballerina-grpc-client-proxy",
     username:"<USERNAME>",
     password:"<PASSWORD>",
     push:true,
     imagePullPolicy:"Always"
 }
listener http:Listener proxyEndpoint = new(8081);

@http:ServiceConfig {
    basePath: "/v1/product"
}
service serviceName on proxyEndpoint {
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/"
    }
    resource function addProduct(http:Caller caller, http:Request request) {
        json|error jsonPayload = request.getJsonPayload();
        if (jsonPayload is json) {
            Product|error constructPayload = Product.constructFrom(jsonPayload);
            if (constructPayload is Product) {
                [string, grpc:Headers]|error productResult = blockingEp->addProduct(constructPayload);
                if (productResult is error) {
                    http:Response response = new;
                    response.statusCode = 500;
                    response.setPayload("Error while adding new product. " + <@untained> <string> productResult.detail()["message"]);
                    error? result = caller->respond(response);
                    if (result is error) {
                        log:printError("Error sending response from proxy service", err = result);
                    }
                } else {
                    [string, grpc:Headers][productID, _] = productResult;
                    error? result = caller->created("v1/product/" + productID, productID + " created successfully.");
                    if (result is error) {
                        log:printError("Error sending response from proxy service", err = result);
                    } 
                }
            } else {
                http:Response response = new;
                response.statusCode = 500;
                response.setPayload("Error while constructing request payload. " + <@untained> <string> constructPayload.detail()["message"]);
                error? result = caller->respond(response);
                if (result is error) {
                    log:printError("Error sending response from proxy service", err = result);
                }
            }
        } else {
            http:Response response = new;
            response.statusCode = 500;
            response.setPayload("Error while reading request payload. " + <@untained> <string> jsonPayload.detail()["message"]);
            error? result = caller->respond(response);
            if (result is error) {
               log:printError("Error sending response from proxy service", err = result);
            }
        }
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/{productid}"
    }
    resource function getProduct(http:Caller caller, http:Request request, string productid) {
        [Product, grpc:Headers]|error productResult = blockingEp->getProduct(productid);
        if (productResult is error) {
            http:Response response = new;
            response.statusCode = 500;
            response.setPayload("Error while reading the product. " + <@untained> <string> productResult.detail()["message"]);
            error? result = caller->respond(response);
            if (result is error) {
                log:printError("Error sending response from proxy service", err = result);
            }
        } else {
            [Product, grpc:Headers][product, _] = productResult;
            json|error productJson = json.constructFrom(product);
            if (productJson is json) {
                error? ok = caller->ok(<@untained> productJson);
                if (ok is error) {
                    log:printError("Error sending response from proxy service", err = ok);
                }
            } else {
                http:Response response = new;
                response.statusCode = 500;
                response.setPayload("Error while constructing request payload. " + <@untained> <string> productJson.detail()["message"]);
                error? result = caller->respond(response);
                if (result is error) {
                    log:printError("Error sending response from proxy service", err = result);
                }
            }
        }
    }
}
