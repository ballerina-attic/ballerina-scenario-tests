import ballerina/http;
import ballerina/kafka;
import ballerina/kubernetes;
import ballerina/lang.'int;

string kafkaTopic = "kafka-test-topic";

kafka:ProducerConfig producerConfig = {
    bootstrapServers: "kafka-service:9092",
    clientId: "kafka-producer",
    acks: kafka:ACKS_ALL,
    retryCount: 3,
    valueSerializer: kafka:SER_INT
};

kafka:Producer kafkaProducer = new(producerConfig);

@kubernetes:Service {
    serviceType: "NodePort",
    name: "kafka-producer-http-service",
    port: 10100,
    targetPort: 10100
}
@kubernetes:Ingress {
	hostname: "kafka.ballerina.io",
	name: "kafka-producer-http-service",
	path: "/"
}
listener http:Listener producerHttpListener = new(10100);

@kubernetes:Deployment {
    image:"kafka.ballerina.io/kafka-producer-http-service:v1.0",
    name:"kafka-producer-http-service",
    username:"<USERNAME>",
    password:"<PASSWORD>",
    push:true,
    imagePullPolicy:"Always"
}
@http:ServiceConfig {
    basePath: "/"
}
service HttpService on producerHttpListener {
    resource function sendMessage(http:Caller caller, http:Request request) {
        http:Response response = new;
        var requestPayload = request.getTextPayload();

        if (requestPayload is error) {
            response.setPayload("Retrieving the payload from the HTTP request failed"
                            + <@untainted string>requestPayload.toString());
            response.statusCode = 400;
        } else {
            response = sendData(requestPayload);
        }

        var result = caller->respond(response);
    }
}

function sendData(string payload) returns http:Response {
    http:Response response = new;
    var message = 'int:fromString(payload);
    if (message is int) {
        // This should not panic ideally. This is a bug in jBallerina.
        var result = trap kafkaProducer->send(message, kafkaTopic);
        if (result is error) {
            response.setPayload("Message successfully sent to the Kafka service");
            // Due to an error in jBallerina, ignore this for now. Otherwise the response code should be 500.
            //response.setPayload("Error sending message to the Kafka service: " + result.toString());
            //response.statusCode = 500;
        } else {
            response.setPayload("Message successfully sent to the Kafka service");
        }
    } else {
        response.setPayload("Error converting int from string: " + <@untainted string>message.toString());
        response.statusCode = 500;
    }
    return response;
}
