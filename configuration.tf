# Set an example kye in the key/value store
provider "consul" {
	address	= "${docker_container.consul.ip_address}:8500"
	datacenter = "dc1"
	scheme	 = "http"
}

resource "consul_service" "elastic-01" {
    address = "${docker_container.elastic.0.ip_address}"
    name = "elastic-01"
    port = 9200
    tags = ["elastic"]
}

resource "consul_service" "elastic-02" {
    address = "${docker_container.elastic.1.ip_address}"
    name = "elastic-02"
    port = 9200
    tags = ["elastic"]
}

resource "consul_service" "elastic-03" {
    address = "${docker_container.elastic.2.ip_address}"
    name = "elastic-03"
    port = 9200
    tags = ["elastic"]
}

resource "consul_service" "elastic-04" {
    address = "${docker_container.elastic.3.ip_address}"
    name = "elastic-04"
    port = 9200
    tags = ["elastic"]
}

resource "consul_service" "elastic-cluster-01" {
    address = "${docker_container.elastic.0.ip_address}"
    name = "elastic"
    port = 9200
    tags = ["elastic", "cluster"]
}

resource "consul_service" "elastic-cluster-02" {
    address = "${docker_container.elastic.1.ip_address}"
    name = "elastic"
    port = 9200
    tags = ["elastic", "cluster"]
}

resource "consul_service" "elastic-cluster-03" {
    address = "${docker_container.elastic.2.ip_address}"
    name = "elastic"
    port = 9200
    tags = ["elastic", "cluster"]
}

resource "consul_service" "elastic-cluster-04" {
    address = "${docker_container.elastic.3.ip_address}"
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