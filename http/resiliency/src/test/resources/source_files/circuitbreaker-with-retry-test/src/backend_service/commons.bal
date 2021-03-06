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
import commons;

int count1 = 0;
int count2 = 0;

string http1ServicePrefix = "[Http1Service] ";
string http2ServicePrefix = "[Http2Service] ";

function sendNormalResponse(http:Caller caller, http:Response response, string prefix, int count) {
    string message = prefix + "OK response. Backend request count: " + count.toString();
    response.setPayload(message);
    var result = caller->respond(response);
    commons:handleResult(result, prefix);
}

function sendErrorResponse(http:Caller caller, http:Response response, string prefix, int count) {
    response.statusCode = 501;
    response.setPayload(prefix + "Internal error occurred. Backend request count: " + count.toString());
    var result = caller->respond(response);
    commons:handleResult(result, prefix);
}
