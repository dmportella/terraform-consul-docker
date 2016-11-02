# Create a container
resource "docker_container" "backend" {
	count = 2
    image = "${docker_image.nginx.latest}"
    name = "website-${format("%02d", count.index+1)}"

    volumes {
		container_path  = "/usr/share/nginx/html"
		host_path = "/home/dmportella/_workspaces/terraform/consul/website/"
		read_only = true
	}
}

resource "docker_container" "lb" {
	depends_on = ["docker_container.backend"]

    image = "${docker_image.nginx.latest}"
    name = "website-lb"

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
		gelf-address = "udp://${docker_container.logstash.ip_address}:3022"
  	}
}

resource "docker_image" "nginx" {
    name = "nginx:1.11.1"
}

resource "null_resource" "cassandra_provisioned" {
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