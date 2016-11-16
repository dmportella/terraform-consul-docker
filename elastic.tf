variable "elastic_count" {
	type = "string"
	default = 3
}

# Create a container
resource "docker_container" "elastic" {
	count = "${var.elastic_count}"
	image = "${docker_image.elastic.name}"
	
	name = "elastic-${format("%02d", count.index+1)}"
	hostname = "elastic-${format("%02d", count.index+1)}"

	restart = "always"

	dns = ["172.17.0.1"]

	dns_search = ["service.consul"]

	labels {
		type = "elastic"
	}

	volumes {
		container_path  = "/usr/share/elasticsearch/data"
		host_path = "/home/dmportella/_workspaces/terraform/consul/data/elastic/data.${format("%d", count.index+1)}"
		read_only = false
	}

	volumes {
		container_path  = "/usr/share/elasticsearch/config"
		host_path = "/home/dmportella/_workspaces/terraform/consul/configs/elastic"
		read_only = false
	}

	log_driver = "gelf"
  	log_opts = {
		gelf-address = "udp://172.17.0.1:3022"
		tag = "elastic"
  	}
}

resource "docker_image" "elastic" {
	name = "elasticsearch:2.4.1"
}

resource "consul_service" "elastic-single" {
    count = "${var.elastic_count}"

    address = "${element(docker_container.elastic.*.ip_address, count.index)}"
    name = "elastic-${format("%02d", count.index+1)}"
    port = 9200
    tags = ["elastic"]

    depends_on = ["docker_container.consul", "docker_container.consul_servers"]
}

resource "consul_service" "elastic-cluster" {
    count = "${var.elastic_count}"

    service_id = "elastic-cluster-${format("%02d", count.index+1)}"

    address = "${element(docker_container.elastic.*.ip_address, count.index)}"
    name = "elastic"
    port = 9200
    tags = ["elastic", "cluster"]

    depends_on = ["docker_container.consul", "docker_container.consul_servers"]
}

output "elastic_servers" {
	value = "${join(",", docker_container.elastic.*.ip_address)}"
}