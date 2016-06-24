variable "environment" {
	default = "develop"
}

# Configure the Docker provider
provider "docker" {
	host = "unix:///var/run/docker.sock"
}