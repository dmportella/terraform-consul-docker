resource "docker_image" "zookeeper" {
    name = "zookeeper:3.4.9"
}

variable "zookeeper_instances" {
	type = "map"
	default = {
		"server.1" = "zookeeper-01" 
		"server.2" = "zookeeper-02" 
		"server.3" = "zookeeper-03"
	}
}

resource "docker_container" "zookeeper" {
	count = "${length(values(var.zookeeper_instances))}"

	name = "${element(values(var.zookeeper_instances), count.index)}"

	image = "${docker_image.zookeeper.latest}"

	hostname = "${element(values(var.zookeeper_instances), count.index)}"

	dns = ["172.17.0.1"]

	dns_search = ["service.consul"]

	env = [
		"ZOO_MY_ID=${count.index + 1}",
		"ZOO_SERVERS=${join(" ", formatlist("%s=%s:2888:3888", keys(var.zookeeper_instances), values(var.zookeeper_instances)))}"
	]

	log_driver = "json-file"
  	log_opts = {
		max-size = "1m"
		max-file = 2
  	}
}

resource "consul_service" "zookeeper-single" {
    count = "${length(values(var.zookeeper_instances))}"

    address = "${element(docker_container.zookeeper.*.ip_address, count.index)}"
    name = "zookeeper-${format("%02d", count.index + 1)}"
    port = 2888
    tags = ["zookeeper"]
}

resource "consul_service" "zookeeper-cluster" {
    count = "${length(values(var.zookeeper_instances))}"

    service_id = "zookeeper-cluster-${format("%02d", count.index + 1)}"

    address = "${element(docker_container.zookeeper.*.ip_address, count.index)}"
    name = "zookeeper"
    port = 2888
    tags = ["zookeeper", "cluster"]
}