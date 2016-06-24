# Create a container
resource "docker_container" "elastic" {
	count = 1
	image = "${docker_image.elastic.name}"
	name = "elastic"

	restart = "always"
	memory = 512

	labels {
		type = "elastic"
	}

	ports {
		internal = 9300
		external = 9300
	}

	ports {
		internal = 9200
		external = 9200
	}

#	volumes {
#		container_path  = "/usr/share/elasticsearch/data"
#		host_path = "/home/dmportella/_volumes/elastic/data"
#		read_only = false
#	}
#
#	volumes {
#		container_path  = "/usr/share/elasticsearch/config"
#		host_path = "/home/dmportella/_volumes/elastic/config"
#		read_only = false
#	}
}

resource "docker_image" "elastic" {
	name = "elasticsearch:2.3.3"
}

output "elastic_ip" {
	value = "${docker_container.elastic.ip_address}"
}