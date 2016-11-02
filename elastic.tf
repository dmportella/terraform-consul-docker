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
	memory = 512

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
}

resource "docker_image" "elastic" {
	name = "elasticsearch:2.4.1"
}

output "elastic_1_ip" {
	value = "${docker_container.elastic.0.ip_address}"
}

output "elastic_2_ip" {
	value = "${docker_container.elastic.1.ip_address}"
}

output "elastic_3_ip" {
	value = "${docker_container.elastic.2.ip_address}"
}