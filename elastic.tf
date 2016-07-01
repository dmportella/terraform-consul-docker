# Create a container
resource "docker_container" "elastic" {
	count = 3
	image = "${docker_image.elastic.name}"
	
	name = "elastic-${format("%02d", count.index+1)}"
	hostname = "elastic-${format("%02d", count.index+1)}"

	restart = "always"
	memory = 512

	dns = ["172.17.0.1"]

	labels {
		type = "elastic"
	}

	volumes {
		container_path  = "/usr/share/elasticsearch/data"
		host_path = "/home/dmportella/_volumes/elastic/data.${format("%d", count.index+1)}"
		read_only = false
	}

	volumes {
		container_path  = "/usr/share/elasticsearch/config"
		host_path = "/home/dmportella/_volumes/elastic/config"
		read_only = false
	}
}

resource "docker_image" "elastic" {
	name = "elasticsearch:2.3.3"
}

output "elastic_0_ip" {
	value = "${docker_container.elastic.0.ip_address}"
}

output "elastic_1_ip" {
	value = "${docker_container.elastic.1.ip_address}"
}

output "elastic_2_ip" {
	value = "${docker_container.elastic.2.ip_address}"
}