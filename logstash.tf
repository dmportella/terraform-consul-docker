# Create a container
resource "docker_container" "logstash" {
	count = 1
	image = "${docker_image.logstash.name}"
	
	name = "logstash-${format("%02d", count.index+1)}"
	hostname = "logstash-${format("%02d", count.index+1)}"

	restart = "always"

	dns = ["172.17.0.1", "8.8.8.8"]

	dns_search = ["service.consul"]

	ports {
		internal = 5044
		external = 5044
		ip = "172.17.0.1"
	}

	ports {
		internal = 3018
		external = 3018
		protocol = "udp"
		ip = "172.17.0.1"
	}

	ports {
		internal = 3019
		external = 3019
		protocol = "tcp"
		ip = "172.17.0.1"
	}

	ports {
		internal = 3020
		external = 3020
		protocol = "udp"
		ip = "172.17.0.1"
	}

	ports {
		internal = 3021
		external = 3021
		protocol = "tcp"
		ip = "172.17.0.1"
	}

	ports {
		internal = 3022
		external = 3022
		protocol = "udp"
		ip = "172.17.0.1"
	}
	
	labels {
		type = "logstash"
	}

	volumes {
		container_path  = "/usr/share/logstash/pipeline/"
		host_path = "/home/dmportella/_workspaces/terraform/consul/configs/logstash/pipeline"
		read_only = true
	}

	volumes {
		container_path  = "/usr/share/logstash/config/"
		host_path = "/home/dmportella/_workspaces/terraform/consul/configs/logstash/settings"
		read_only = true
	}
}

resource "docker_image" "logstash" {
	name = "docker.elastic.co/logstash/logstash:5.2.2"
}

output "logstash_ip" {
	value = "${docker_container.logstash.ip_address}"
}
