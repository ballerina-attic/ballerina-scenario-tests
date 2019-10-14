import ballerina/nats;
import ballerina/kubernetes;
import ballerina/log;

// Initializes a connection.
nats:Connection subscriberConnection = new("nats://example-nats-cluster:4222");

@kubernetes:Deployment {
    //livenessProbe: true, NPE Occurred when this was enabled..
    image:"ballerina.guides.io/natstest:latest",
    name: "nats-subscriber-service-deployment"
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
