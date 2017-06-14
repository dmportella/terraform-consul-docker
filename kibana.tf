# Create a container
resource "docker_container" "kibana" {
	count = 1
	image = "${docker_image.kibana.name}"
	name = "kibana"

	restart = "always"
	
	dns = ["172.17.0.1", "8.8.8.8"]

	dns_search = ["service.consul"]

	ports {
		internal = 5601
		external = 5601
	}

	labels {
		type = "kibana"
	}

	volumes {
		container_path  = "/usr/share/kibana/config"
		host_path = "/home/dmportella/_workspaces/terraform/consul/configs/kibana"
		read_only = true
	}

	log_driver = "gelf"
	log_opts = {
		gelf-address = "udp://172.17.0.1:3022"
		tag = "kibana"
	}
}

resource "docker_image" "kibana" {
	name = "docker.elastic.co/kibana/kibana:5.4.1"
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