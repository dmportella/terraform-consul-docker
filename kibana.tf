# Create a container
resource "docker_container" "kibana" {
	count = 1
	image = "${docker_image.kibana.name}"
	name = "kibana"

	restart = "always"
	memory = 512

	ports {
		internal = 5601
		external = 5601
	}

	labels {
		type = "kibana"
	}

	links = ["${docker_container.elastic.name}:elasticsearch"]
}

resource "docker_image" "kibana" {
	name = "kibana:4.5.1"
}

output "kibana_ip" {
	value = "${docker_container.kibana.ip_address}"
}