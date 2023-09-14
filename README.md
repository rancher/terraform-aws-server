# Terraform AWS Server

WARNING! this module is for experimental use only

This module deploys infrastructure in AWS.

This is a "Core Module", it shouldn't contain any nested "independent modules". Please see [terraform.md](./terraform.md) for more information.

## AWS Access

The first step to using the AWS modules is having an AWS account, [here](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-creating.html) is a document describing this process.
You will need an API access key id and API secret key, you can get the API keys [following this tutorial](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey).
The Terraform AWS provider uses the AWS Go SDK, which allows the use of either environment variables or [config files](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-settings) for authentication.
You do not need the AWS cli to generate the files, just place them in the proper place and Terraform will find and read them.

## Examples

### Local State

The specific use case for the example modules is temporary infrastructure for testing purposes.
With that in mind, it is not expected that we manage the resources as a team, therefore the state files are all stored locally.
If you would like to store the state files remotely, add a terraform backend file (`*.name.tfbackend`) to your implementation module.
https://www.terraform.io/language/settings/backends/configuration#file

## Development and Testing

### Paradigms and Expectations

Please make sure to read [terraform.md](./terraform.md) to understand the paradigms and expectations that this module has for development.
This is a "Core" module, as such it is not allowed to call other modules, and must only generate resources.

### Environment

It is important to us that all collaborators have the ability to develop in similar environments, so we use tools which enable this as much as possible.
These tools are not necessary, but they can make it much simpler to collaborate.

* I use [nix](https://nixos.org/) that I have installed using [their recommended script](https://nixos.org/download.html#nix-install-macos)
* I use [direnv](https://direnv.net/) that I have installed using brew.
* I simply use `direnv allow` to enter the environment
* I navigate to the `tests` directory and run `go test -v -timeout=40m -parallel=10`
  * It is important to note that the test files do not stand alone, they expect to run as a package.
  * This means that specifying the file to test (as follows) will fail: `go test -v -timeout 40m -parallel 10 basic_test.go`
* To run an individual test I navigate to the `tests` directory and run `go test -v -timeout 40m -parallel 10 -run <test function name>`
  * eg. `go test -v -timeout 40m -parallel 10 -run TestBasic`
* I use `override.tf` files to change the values of `examples` to personalized data so that I can run them.
  * some examples use variables so that I can dynamically add values in tests
* I store my GitHub credentials in a local file and generate a symlink to them named `~/.config/github/default/rc`
  * this will be automatically sourced when you enter the nix environment (and unloaded when you leave)

Our continuous integration tests in the GitHub [ubuntu-latest runner](https://github.com/actions/runner-images/blob/main/images/linux/Ubuntu2204-Readme.md), which has many different things installed and does not rely on Nix.
It also uses a custom role and user which has been set up for it.
