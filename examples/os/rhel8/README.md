# RHEL8 Example

This is an example of using this module to deploy a small rhel8 server on AWS.

This example has been validated using [Terratest](https://terratest.gruntwork.io/), a Go sdk and test suite for Terraform.
If you would like to test this example go to the ./tests directory and run the test with `go test os_test.go` or `go test -v -run TestRhel8`.
