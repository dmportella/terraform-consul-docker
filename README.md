# terraform-consul-docker

Small repo for playing around using terraform to setup docker environment with consul cluster and other containers like couchdb, neo4j etc.

## Terraform

Check everything is oke.

`terraform plan`

Apply changes.

`terraform apply`

# Setup Includes

* Consul Cluster managing dns
* elastic search cluster
* kibana pointing at elastic cluster (dns load balancing from consul)
* logstash pointing at elastic cluster (dns load balancing from consul)
* zookeeper cluster 
* kafka cluster
* all containers sending logs to logstash

