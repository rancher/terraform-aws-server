# Server Only Example

This is an example of using this module to deploy a small sles15 server, specifying the ami to use.
If you specify an image_id, you must also specify the admin_group and initial_user.
These are used to login to the server for the first time and set up a new user as specified by "username".

This example has been validated using [Terratest](https://terratest.gruntwork.io/), a Go sdk and test suite for Terraform.
If you would like to test this example go to the ./tests directory and run the test with `go test -v -run TestServerOnly`.
