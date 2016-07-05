# Create a container
resource "docker_container" "logstash" {
	count = 1
	image = "${docker_image.logstash.name}"
	
	name = "logstash-${format("%02d", count.index+1)}"
	hostname = "logstash-${format("%02d", count.index+1)}"

	restart = "always"
	memory = 512

	dns = ["172.17.0.1"]

	labels {
		type = "logstash"
	}

	volumes {
		container_path  = "/config-dir"
		host_path = "/home/dmportella/_volumes/logstash/config"
		read_only = false
	}
}

resource "docker_image" "logstash" {
	name = "logstash:2.3.3-1"
}

output "logstash_ip" {
	value = "${docker_container.logstash.ip_address}"
}
