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

public type ProductInfoBlockingClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function __init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        grpc:Client c = new(url, config);
        grpc:Error? result = c.initStub(self, "blocking", ROOT_DESCRIPTOR, getDescriptorMap());
        if (result is grpc:Error) {
            error err = result;
            panic err;
        } else {
            self.grpcClient = c;
        }
    }

    public remote function addProduct(Product req, grpc:Headers? headers = ()) returns ([string, grpc:Headers]|grpc:Error) {
        var payload = check self.grpcClient->blockingExecute("ecommerce.ProductInfo/addProduct", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        return [result.toString(), resHeaders];
    }

    public remote function getProduct(string req, grpc:Headers? headers = ()) returns ([Product, grpc:Headers]|grpc:Error) {
        var payload = check self.grpcClient->blockingExecute("ecommerce.ProductInfo/getProduct", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        var value = typedesc<Product>.constructFrom(result);
        if (value is Product) {
            return [value, resHeaders];
        } else {
            return grpc:prepareError(grpc:INTERNAL_ERROR, "Error while constructing the message", value);
        }
    }

};

public type ProductInfoClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function __init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        grpc:Client c = new(url, config);
        grpc:Error? result = c.initStub(self, "non-blocking", ROOT_DESCRIPTOR, getDescriptorMap());
        if (result is grpc:Error) {
            error err = result;
            panic err;
        } else {
            self.grpcClient = c;
        }
    }

    public remote function addProduct(Product req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        return self.grpcClient->nonBlockingExecute("ecommerce.ProductInfo/addProduct", req, msgListener, headers);
    }

    public remote function getProduct(string req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        return self.grpcClient->nonBlockingExecute("ecommerce.ProductInfo/getProduct", req, msgListener, headers);
    }

};

public type Product record {|
    string id = "";
    string name = "";
    string description = "";
    float price = 0.0;
    
|};

const string ROOT_DESCRIPTOR = "0A1270726F647563745F696E666F2E70726F746F120965636F6D6D657263651A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22650A0750726F64756374120E0A0269641801200128095202696412120A046E616D6518022001280952046E616D6512200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12140A05707269636518042001280252057072696365328D010A0B50726F64756374496E666F123E0A0A61646450726F6475637412122E65636F6D6D657263652E50726F647563741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565123E0A0A67657450726F64756374121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A122E65636F6D6D657263652E50726F64756374620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "product_info.proto":"0A1270726F647563745F696E666F2E70726F746F120965636F6D6D657263651A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F22650A0750726F64756374120E0A0269641801200128095202696412120A046E616D6518022001280952046E616D6512200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12140A05707269636518042001280252057072696365328D010A0B50726F64756374496E666F123E0A0A61646450726F6475637412122E65636F6D6D657263652E50726F647563741A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565123E0A0A67657450726F64756374121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A122E65636F6D6D657263652E50726F64756374620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"
        
    };
}
