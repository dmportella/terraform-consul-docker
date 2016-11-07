resource "docker_image" "zafka" {
    name = "ches/kafka:0.10.1.0"
}

resource "docker_container" "zafka" {
	count = "3"

	name = "kafka-${format("%02d", count.index+1)}"

	image = "${docker_image.zafka.latest}"

	hostname = "kafka-${format("%02d", count.index+1)}"

	restart = "always"

	dns = ["172.17.0.1"]

	dns_search = ["service.consul"]

	env = [
		"KAFKA_BROKER_ID=${count.index + 1}",
		"ZOOKEEPER_CONNECTION_STRING=${join(",", formatlist("%s.service.consul:2181", values(var.zookeeper_instances)))}"
	]

	log_driver = "gelf"
	log_opts = {
		gelf-address = "udp://${docker_container.logstash.ip_address}:3022"
		tag = "kafka"
	}
}

resource "consul_service" "zafka-single" {
    count = "3"

    address = "${element(docker_container.zafka.*.ip_address, count.index)}"
    name = "zafka-${format("%02d", count.index + 1)}"
    port = 2181
    tags = ["zafka"]

    depends_on = ["docker_container.consul", "docker_container.consul_servers"]
}

resource "consul_service" "zafka-cluster" {
    count = "3"

    service_id = "zafka-cluster-${format("%02d", count.index + 1)}"

    address = "${element(docker_container.zafka.*.ip_address, count.index)}"
    name = "kafka"
    port = 2181
    tags = ["zafka", "cluster"]

    depends_on = ["docker_container.consul", "docker_container.consul_servers"]
}

output "kafka_servers" {
	value = "${join(",", docker_container.zafka.*.ip_address)}"
}