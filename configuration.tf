# Set an example kye in the key/value store
provider "consul" {
	address	= "${null_resource.consul_provisioned.triggers["cluster_master"]}:8500"
	datacenter = "dc1"
	scheme	 = "http"
}

resource "consul_service" "elastic-single" {
    count = "${var.elastic_count}"

    address = "${element(docker_container.elastic.*.ip_address, count.index)}"
    name = "elastic-${format("%02d", count.index+1)}"
    port = 9200
    tags = ["elastic"]
}

resource "consul_service" "elastic-cluster" {
    count = "${var.elastic_count}"

    service_id = "elastic-cluster-${format("%02d", count.index+1)}"

    address = "${element(docker_container.elastic.*.ip_address, count.index)}"
    name = "elastic"
    port = 9200
    tags = ["elastic", "cluster"]
}

resource "consul_service" "kibana" {
    address = "${docker_container.kibana.ip_address}"
    name = "kibana"
    port = 5601
    tags = ["kibana"]
}