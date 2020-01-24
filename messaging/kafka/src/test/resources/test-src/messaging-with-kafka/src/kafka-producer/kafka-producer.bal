import ballerina/http;
import ballerina/kafka;
import ballerina/kubernetes;

string kafkaTopic = "kafka-test-topic";
string resultString = "";

kafka:ProducerConfig producerConfig = {
    bootstrapServers: "kafka-service:9092",
    clientId: "kafka-producer",
    acks: "all",
    retryCount: 3,
    valueSerializer: kafka:SER_STRING
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
            byte[] serializedMessage = requestPayload.toBytes();
            var result = kafkaProducer->send(serializedMessage, kafkaTopic);
            if (result is error) {
                response.setPayload("Error sending message to the Kafka service: " + result.toString());
                response.statusCode = 500;
            } else {
                response.setPayload("Message successfully sent to the Kafka service");
            }
        }

        var result = caller->respond(response);
    }
}
