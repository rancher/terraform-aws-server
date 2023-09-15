# Specific Security Group Example

This is an example of using this module to deploy a small sles15 server on AWS with the "egress" security group type.

This example has been validated using [Terratest](https://terratest.gruntwork.io/), a Go sdk and test suite for Terraform.
If you would like to test this example go to the ./tests directory and run the test with `go test -v -run TestSpecific`

## Security Group Type

We provide a selection of security group "types" which produces archetypical objects in AWS.

The basic security group adds the single IP of the server running Terraform, allowing it access to the server created for the purpose of validation and configuration, we call this type "specific". This is the type selected for this example.
