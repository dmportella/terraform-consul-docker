# Create a container
resource "docker_container" "couchdb" {
	count = 1
    image = "${docker_image.couchdb.name}"
    name = "couchdb"

    ports {
    	internal = 5984
    	external = 5984
    }

	restart = "always"
	memory = 128

	labels {
		type = "couchdb"
	}

    volumes {
		container_path  = "/usr/local/var/lib/couchdb"
		host_path = "/home/dmportella/_volumes/couchdb"
		read_only = false
	}
}

resource "docker_image" "couchdb" {
    name = "couchdb:1.6.1"
}

output "couchdb_ip" {
	value = "${docker_container.couchdb.ip_address}"
}