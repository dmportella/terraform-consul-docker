# Create a container
resource "docker_container" "neo4j" {
	count = 1
	image = "${docker_image.neo4j.name}"
	name = "neo4j"

	ports {
		internal = 7474
		external = 7474
	}

	restart = "always"
	memory = 512

	labels {
		type = "neo4j"
	}

	volumes {
		container_path  = "/data"
		host_path = "/home/dmportella/_volumes/neo4j"
		read_only = false
	}
}

resource "docker_image" "neo4j" {
	name = "neo4j:3.0.2"
}

output "neo4j_ip" {
	value = "${docker_container.neo4j.ip_address}"
}