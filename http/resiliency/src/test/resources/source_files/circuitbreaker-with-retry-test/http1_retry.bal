import ballerina/http;
import ballerina/io;
import ballerina/log;

// ****************************************************
//                RETRY CLIENT SERVICE                *
// ****************************************************

http:Client backendClientEP = new("http://localhost:10200", {
    retryConfig: {
        intervalInMillis: 3000,
        count: 10,
        backOffFactor: 2.0,
        maxWaitIntervalInMillis: 20000,
        statusCodes: [400, 401, 402, 403, 404, 500, 501, 502, 503]
    },
    timeoutInMillis: 2000
});

listener http:Listener retryListener = new(10100);

string servicePrefix = "[RetryService] ";
int count = 0;

@http:ServiceConfig {
    basePath: "/"
}
service RetryService on retryListener {
    @http:ResourceConfig {
        methods: ["GET"]
	}
    resource function getResponse(http:Caller caller, http:Request request) {
        count += 1;
        log:printInfo(servicePrefix + "Request Received. Request Count: " + count.toString());
        var backendResponse = backendClientEP->forward("/getResponse", request);
        http:Response response = new;
        if (backendResponse is http:ClientError) {
            io:println(backendResponse);
            response.statusCode = 501;
            response.setTextPayload(<@untainted string> backendResponse.toString() + " Retry request count: " +
                                    count.toString());
        } else {
            io:println(backendResponse.getTextPayload());
            string backendResponsePayload = <@untainted string> backendResponse.getTextPayload();
            response.setTextPayload(backendResponsePayload + " Retry request count: " + count.toString());
        }
        var sendResult = caller->respond(response);
        handleResult(sendResult);
	}
}

public function handleResult(error? result) {
    if (result is error) {
        log:printError(servicePrefix + "Error occurred while sending the response", result);
    } else {
        log:printInfo(servicePrefix + "Response sent successfully\n");
    }
}
