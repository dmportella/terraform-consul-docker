# terraform-consul-docker

Small repo for playing around using terraform to setup docker environment with consul cluster and other containers like couchdb, neo4j etc.

## Stopping docker daemon

`sudo service docker stop`

## Starting docker daemon with http api on

`sudo docker daemon -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock`

## Terraform

Check everything is oke.

`terraform plan`

Apply changes.

`terraform apply`
