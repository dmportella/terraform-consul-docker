# Create a container
resource "docker_container" "backend" {
	count = 2
    image = "${docker_image.nginx.latest}"
    name = "website-${format("%02d", count.index+1)}"

    dns = ["172.17.0.1"]

	dns_search = ["service.consul"]

    volumes {
		container_path  = "/usr/share/nginx/html"
		host_path = "/home/dmportella/_workspaces/terraform/consul/website/"
		read_only = true
	}

	log_driver = "gelf"
	log_opts = {
		gelf-address = "udp://172.17.0.1:3022"
		tag = "nginx-backend"
	}
}

resource "docker_container" "lb" {
	depends_on = ["docker_container.backend"]

    image = "${docker_image.nginx.latest}"
    name = "website-lb"

    dns = ["172.17.0.1"]

	dns_search = ["service.consul"]

    ports {
    	external = 9090
    	internal = 80
    }

    volumes {
		container_path  = "/etc/nginx"
		host_path = "/home/dmportella/_workspaces/terraform/consul/configs/nginx/lb"
		read_only = true
	}

	log_driver = "gelf"
  	log_opts = {
		gelf-address = "udp://172.17.0.1:3022"
		tag = "nginx-lb"
  	}
}

resource "docker_image" "nginx" {
    name = "nginx:1.11.1"
}

resource "null_resource" "nginx_provisioned" {
	depends_on = ["docker_container.backend", "docker_container.lb"]
	
	provisioner "local-exec" {
		command = "echo \"${data.template_file.nginx_config.rendered}\" > ./configs/nginx/lb/nginx.conf && docker exec ${docker_container.lb.name} nginx -s reload"
	}

	triggers {
		loadBalancer = "${docker_container.lb.ip_address}"
    	cluster_servers = "${join(",", docker_container.backend.*.ip_address)}"
	}
}

data "template_file" "nginx_config" {
    template = "${file("${path.module}/configs/nginx/nginx.tpl")}"

    vars {
        upstream_list = "${join(",", docker_container.backend.*.ip_address)}"
    }
}

output "nginx_servers" {
	value = "${join(",", docker_container.backend.*.ip_address)}"
}

output "nginx_lb_server" {
	value = "${join(",", docker_container.lb.ip_address)}"
}