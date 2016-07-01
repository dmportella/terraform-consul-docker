# Set an example kye in the key/value store
provider "consul" {
	address	= "${docker_container.consul.ip_address}:8500"
	datacenter = "dc1"
	scheme	 = "http"
}

resource "consul_keys" "example_key" {
	depends_on = ["null_resource.consul_provisioned"]
	datacenter = "dc1"
	key {
		name  = "feature-switch"
		path  = "settings/feature-switch"
		value = "on"
	}
}