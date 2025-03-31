import ballerinax/kafka;

function transformKafkaEvents(kafka:AnydataConsumerRecord kafkaEvent) returns Price|error => {
    price: check float:fromString(kafkaEvent.value.toString()),
    name: kafkaEvent["key"] != () ? kafkaEvent["key"].toString() : ""
};
