# Basic CIS Example

This is an example of using this module to deploy a small sles15 server using the CIS Benchmark Level 1 approved image on AWS.

WARNING! This image requires a subscription and will cost a bit extra.

The only way I could find to subscribe was to login to the EC2 console and apply here:
https://aws.amazon.com/marketplace/seller-profile?id=dfa1e6a8-0b7b-4d35-a59c-ce272caee4fc&ref_=beagle

This example has been validated using [Terratest](https://terratest.gruntwork.io/), a Go sdk and test suite for Terraform.
If you would like to test this example go to the ./tests directory and run the test with `go test -v -parallel=10 -timeout=20m -run=TestSles15Cis`.
