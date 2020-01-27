import ballerina/http;
import ballerina/kafka;
import ballerina/kubernetes;

string resultString = "";

kafka:ConsumerConfig consumerConfig = {
    bootstrapServers: "kafka-service:9092",
    groupId: "kafka-consumer-group",
    clientId: "simple-consumer",
    offsetReset: "earliest",
    topics: ["kafka-test-topic"],
    valueDeserializer: kafka:SER_INT
};

listener kafka:Consumer kafkaConsumer = new(consumerConfig);

service KafkaService on kafkaConsumer {
    resource function onMessage(kafka:Consumer consumer, kafka:ConsumerRecord[] records) {
        foreach var kafkaRecord in records {
            var message = kafkaRecord.value;
            if (message is int) {
                resultString = <@untainted string> message.toString();
            } else {
                resultString = "Error converting from bytes";
            }
        }
    }
}

@kubernetes:Service {
    serviceType: "NodePort",
    name: "kafka-consumer-http-service",
    port: 10200,
    targetPort: 10200
}
@kubernetes:Ingress {
	hostname: "kafka.ballerina.io",
	name: "kafka-consumer-http-service",
	path: "/"
}
listener http:Listener consumerHttpListener = new(10200);

@kubernetes:Deployment {
    image:"kafka.ballerina.io/kafka-consumer-http-service:v1.0",
    name:"kafka-consumer-http-service",
    username:"<USERNAME>",
    password:"<PASSWORD>",
    push:true,
    imagePullPolicy:"Always"
}
@http:ServiceConfig {
    basePath: "/"
}
service HttpService on consumerHttpListener {
    resource function getResult(http:Caller caller, http:Request request) {
        http:Response response = new;

        if (resultString == "") {
            response.statusCode = 501;
        }
        response.setPayload(resultString);
        var result = caller->respond(response);
    }
}
