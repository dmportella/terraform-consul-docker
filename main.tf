variable "environment" {
	default = "develop"
}

# Configure the Docker provider
provider "docker" {
    host = "tcp://0.0.0.0:2375/"
}