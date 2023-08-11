# Image Only Example

This example has been validated using [Terratest](https://terratest.gruntwork.io/), a Go sdk and test suite for Terraform.
If you would like to test this example go to the ./tests/overrides directory and run the test with `go test overrides_test.go` or `go test -v -run TestImageOnly`.

This is an example of using this module to select information rather than creating anything.
This will select the image from the image types and retrieve information about it.
Please see ./image/types.tf for more information on the opinionated image selection this module provides.


NOTE: This module does not create images, it may select them or skip them (potentially requiring the user to provide more information), but it won't create them.
