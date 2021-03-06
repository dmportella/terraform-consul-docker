# Create a container
resource "docker_container" "kibana" {
	count = 1
	image = "${docker_image.kibana.name}"
	name = "kibana"

	restart = "always"
	
	dns = ["172.17.0.1"]

	dns_search = ["service.consul"]

	env = ["ELASTICSEARCH_URL=http://elastic.service.consul:9200"]

	ports {
		internal = 5601
		external = 5601
	}

	labels {
		type = "kibana"
	}

	log_driver = "gelf"
	log_opts = {
		gelf-address = "udp://172.17.0.1:3022"
		tag = "kibana"
	}
}

resource "docker_image" "kibana" {
	name = "kibana:4.5.1"
}

resource "consul_service" "kibana" {
    address = "${docker_container.kibana.ip_address}"
    name = "kibana"
    port = 5601
    tags = ["kibana"]

    depends_on = ["docker_container.consul", "docker_container.consul_servers"]
}

output "kibana_ip" {
	value = "${docker_container.kibana.ip_address}"
}