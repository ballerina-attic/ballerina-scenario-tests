/*
 *  Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package main

import (
    "net/http"
    "strconv"
    "time"
)

var prefix string = "[Http2Service] "
var count int = 0

func main() {
    http.HandleFunc("/getResponse", sendResponse)
    http.ListenAndServe(":10400", nil)
}

func sendResponse(writer http.ResponseWriter, request *http.Request) {
    count++;
    var modulus int = count % 4

    if modulus == 0 || modulus == 3 {
        sendOkResponse(writer)
    } else if modulus == 1 {
        time.Sleep(5 * time.Second)
        sendErrorResponse(writer)
    } else {
        sendErrorResponse(writer)
    }
}

func sendOkResponse(writer http.ResponseWriter) {
    var message string = prefix + "OK response. Backend request count: " + strconv.Itoa(count)
    writer.Write([]byte(message))
}

func sendErrorResponse(writer http.ResponseWriter) {
    var message string = prefix + "Internal server error. Backend request count: " + strconv.Itoa(count)
    writer.WriteHeader(http.StatusInternalServerError)
    writer.Write([]byte(message))
}
