import ballerinax/kafka;
import ballerina/io;

listener kafka:Listener kafkaListener = new (bootstrapServers = kafka:DEFAULT_URL, groupId = "order-group-id", topics = "product_price_updates");

service kafka:Service on kafkaListener {

    function init() {
        io:println("Kafka service started");
    }
    
    remote function onConsumerRecord(kafka:AnydataConsumerRecord[] records, kafka:Caller caller) returns error? {
        do {
            foreach kafka:AnydataConsumerRecord event in records {
                Price price = check transformKafkaEvents(event);
                stream<record {||}, error?> productIdStream = check salesforceClient->query(string `SELECT Id FROM PricebookEntry WHERE Pricebook2Id = '${salesforcePriceBookId}' AND Name = '${price.name}'`);
                record {}[] productIds = check from record {} result in productIdStream
                    select result;
                anydata productId = productIds[0]["Id"];
                if productId is string {
                    check salesforceClient->update("PricebookEntry", salesforcePriceBookId, {"UnitPrice": price.price});
                }
            }

        } on fail error err {
            // handle error
            return error("Something went wrong", err);
        }
    }
}
