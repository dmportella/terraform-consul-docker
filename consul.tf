# Create a container
resource "docker_container" "consul" {
	count = 1
	image = "${docker_image.consul.name}"
	name = "consul-master"
	hostname = "consul-master"

	restart = "always"
	memory = 512

	labels {
		type = "consul"
	}

	ports {
		internal = 8300
		external = 8300
	}

	ports {
		internal = 8301
		external = 8301
	}

	ports {
		internal = 8301
		external = 8301
		protocol = "udp"
	}

	ports {
		internal = 8302
		external = 8302
	}

	ports {
		internal = 8302
		external = 8302
		protocol = "udp"
	}

	ports {
		internal = 8400
		external = 8400
	}

	ports {
		internal = 8500
		external = 8500
	}

	ports {
		internal = 8600
		external = 8600
	}

	ports {
		internal = 8600
		external = 8600
		protocol = "udp"
	}

	volumes {
		container_path  = "/consul/data"
		host_path = "/home/dmportella/_volumes/consul"
		read_only = false
	}

	command = ["agent", "-dev", "-client=0.0.0.0", "-bootstrap-expect=1", "-ui"]
}

resource "docker_container" "consul_agents" {
	count = 4
	image = "${docker_image.consul.name}"
	name = "consul-agent-${format("%02d", count.index+1)}"
	hostname = "consul-agent-${format("%02d", count.index+1)}"
	
	labels {
		type = "consul agent"
	}

	restart = "always"
	memory = 512

	command = ["agent", "-dev", "-join=${docker_container.consul.ip_address}"]
}

resource "docker_image" "consul" {
	name = "consul:v0.6.4"
}

output "consul_ip" {
	value = "${docker_container.consul.ip_address}"
}