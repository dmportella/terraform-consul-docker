# Create a container
resource "docker_container" "consul" {
	count = 1
	image = "${docker_image.consul.name}"
	name = "consul-master"
	hostname = "consul-master"

	restart = "always"
	memory = 512
	privileged = true

	labels {
		type = "consul"
	}

	ports {
		internal = 8500
		external = 8500
		ip = "127.0.0.1"
	}

	ports {
		internal = 8500
		external = 8500
		ip = "172.17.0.1"
	}

	ports {
		internal = 8600
		external = 53
		ip = "172.17.0.1"
	}

	ports {
		internal = 8600
		external = 53
		protocol = "udp"
		ip = "172.17.0.1"
	}

	volumes {
		container_path  = "/consul/data"
		host_path = "/home/dmportella/_volumes/consul"
		read_only = false
	}

	command = ["agent", "-dev", "-client=0.0.0.0", "-bind=0.0.0.0","-bootstrap-expect=1", "-ui"]
}

resource "docker_container" "consul_servers" {
	count = 2
	image = "${docker_image.consul.name}"
	name = "consul-server-${format("%02d", count.index+1)}"
	hostname = "consul-server-${format("%02d", count.index+1)}"
	
	labels {
		type = "consul server"
	}

	restart = "always"
	memory = 512

	command = ["agent", "-dev", "-server","-join=${docker_container.consul.ip_address}"]
}

resource "docker_container" "consul_agents" {
	count = 1
	image = "${docker_image.consul.name}"
	name = "consul-agent-${format("%02d", count.index+1)}"
	hostname = "consul-agent-${format("%02d", count.index+1)}"
	
	labels {
		type = "consul agent"
	}

	restart = "always"
	memory = 512

	command = ["agent","-join=${docker_container.consul.ip_address}"]
}

resource "docker_image" "consul" {
	name = "consul:v0.6.4"
}

output "consul_master_ip" {
	value = "${docker_container.consul.ip_address}"
}

output "consul_servers" {
	value = "${join(",", docker_container.consul_servers.*.ip_address)}"
}

output "consul_host_agent" {
	value = "${docker_container.consul_agents.ip_address}"
}

resource "null_resource" "consul_provisioned" {
	triggers {
		cluster_master = "${docker_container.consul.ip_address}"
    	cluster_servers = "${join(",", docker_container.consul_servers.*.ip_address)}"
    	host_agent = "${docker_container.consul_agents.ip_address}"
  	}
	depends_on = ["docker_container.consul", "docker_container.consul_servers", "docker_container.consul_agents"]
}