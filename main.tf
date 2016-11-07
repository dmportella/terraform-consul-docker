variable "environment" {
	default = "develop"
}

# Configure the Docker provider
provider "docker" {
	host = "unix:///var/run/docker.sock"
}

# Set an example kye in the key/value store
provider "consul" {
	address	= "172.17.0.1:8500"
	datacenter = "dc1"
	scheme	 = "http"
}