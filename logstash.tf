# Create a container
resource "docker_container" "logstash" {
	count = 1
	image = "${docker_image.logstash.name}"
	
	name = "logstash-${format("%02d", count.index+1)}"
	hostname = "logstash-${format("%02d", count.index+1)}"

	restart = "always"

	dns = ["172.17.0.1"]

	dns_search = ["service.consul"]

	labels {
		type = "logstash"
	}

	volumes {
		container_path  = "/config-dir"
		host_path = "/home/dmportella/_workspaces/terraform/consul/configs/logstash/"
		read_only = true
	}

	command = ["logstash", "-f", "/config-dir/logstash.config"]
}

resource "docker_image" "logstash" {
	name = "logstash:2.4.0"
}

output "logstash_ip" {
	value = "${docker_container.logstash.ip_address}"
}
