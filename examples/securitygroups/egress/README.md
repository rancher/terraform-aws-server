# Egress Security Group Example

This is an example of using this module to deploy a small sles15 server on AWS with the "egress" security group type.

This example has been validated using [Terratest](https://terratest.gruntwork.io/), a Go sdk and test suite for Terraform.
If you would like to test this example go to the ./tests directory and run the test with `go test -v -run TestEgress`


## Security Group Type

We provide a selection of security group "types" which produces archetypical objects in AWS.

The basic security group adds the single IP of the server running Terraform, allowing it access to the server created for the purpose of validation and configuration, we call this type "specific".

The next security group adds to the "specific" group by adding rules to allow for internal subnet traffic, in this type the subnet cidr is allowed for both ingress and egress. This type is called "internal".

The next security group duplicates the "internal" type, then adds rules to allow egress only to the public internet. This is helpful if you want to be able to upgrade your server, or if you need your server to be able to download packages from the internet, but you don't want the public internet to be able to initiate connections with your server. Thie type is called "egress", and is the type selected for this example.
