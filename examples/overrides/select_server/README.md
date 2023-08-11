# Select Only Example

This example has been validated using [Terratest](https://terratest.gruntwork.io/), a Go sdk and test suite for Terraform.
If you would like to test this example go to the ./tests directory and run the test with `go test overrides_test.go` or `go test -v -run TestSelectOnly`.

This is an example of using this module to select an image and server without deploying anything.

WARNING! Server values override image values in outputs.
This means that if you select both an image and a server, and the image is not the one that the server uses, then you will not get the image information you selected.
Accurate server information is the top priority for this module, so it will give you the image information related to the server selected.
That makes this example somewhat useless in practice, but it exercises both paths, so we use it in testing.

In most use cases you will want to either select only an image and get the image information, or select only a server to get the server information (including the image that the server is using).
