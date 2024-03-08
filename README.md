# Terraform AWS Server

This module deploys infrastructure in AWS.

## Recent Changes

1. Servers will no longer deploy a public ip by default.
     You can override this by setting up a subnet that automatically deploys public ips.
     You can select to have a public IP added to your server with the 'add_public_ip' boolean variable.
       - this IP will be an elastic ip so it will cost a little bit extra, but will persist between server rebuilds
2. This module has a lean towards enabling the provisioning of kubernetes clusters, so it has some additional requirements
   - the primary network interface's ip should not change even when the server is rebuilt
     - this allows us to have a more stable config and easier data recovery options


## AWS Access

The first step to using the AWS modules is having an AWS account, [here](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-creating.html) is a document describing this process.
You will need an API access key id and API secret key, you can get the API keys [following this tutorial](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey).
The Terraform AWS provider uses the AWS Go SDK, which allows the use of either environment variables or [config files](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-settings) for authentication.

You do not need the AWS cli to generate the files, just place them in the proper place and Terraform will find and read them.

## Server Types

This module provides a pre-chosen set of "types" of servers in order to reduce choice fatigue for the user and streamline testing.
The choices are detailed [in the server module](./modules/server/types.tf) and below:

```
# storage sizes in GB, using gp3 storage type
locals {
  types = {
    small = { # minimum required for rke2 control plane node, handles 0-225 agents
      id      = "t3.medium",
      cpu     = "2",
      ram     = "4",
      storage = "20",
    },
    medium = { # agent node, fits requirements for a database server or a small gaming server
      id      = "m5.large",
      cpu     = "2",
      ram     = "8",
      storage = "200",
    },
    large = { # control plane handling 226-450 agents, also fits requirements for a git server
      id      = "c5.xlarge",
      cpu     = "4",
      ram     = "8",
      storage = "500",
    },
    xl = { # control plane handling 451-1300 agents, also fits requirements for a large database server, gaming server, or a distributed storage solution
      id      = "t3.xlarge",
      cpu     = "4",
      ram     = "16",
      storage = "1000",
    }
    xxl = { # control plane handling 1300+ agents, also fits requirements for a large gaming server, a large database server, or a distributed storage solution
      id      = "m5.2xlarge",
      cpu     = "8",
      ram     = "32",
      storage = "2000",
    }
  }
}
```

### Image types

This module provides a pre-chosen set of "types" of images in order to reduce choice fatigue for the user and streamline testing.
The choices are detailed [in the image module](./modules/image/types.tf) and below:

```
locals {
  types = {
    sles-15 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "suse-sles-15-sp5-v*-hvm-*",
      owner        = "amazon",
      architecture = "x86_64",
      workfolder   = "~"
    },
    sles-15-cis = { # WARNING! this AMI requires subscription to a service, it is not free
      user         = "ec2-user",
      group        = "wheel",
      name         = "CIS SUSE Linux Enterprise 15*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
      workfolder   = "~"
    },
    rhel-8-cis = { # WARNING! this AMI requires subscription to a service, it is not free https://aws.amazon.com/marketplace/server/procurement?productId=ca1fe94d-9237-41c7-8fc8-78b6b0658c9f
      user         = "ec2-user",
      group        = "wheel",
      name         = "CIS Red Hat Enterprise Linux 8 STIG Benchmark*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
      workfolder   = "/var/tmp"
    },
    ubuntu-20 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
      workfolder   = "~"
    },
    ubuntu-22 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
      workfolder   = "~"
    },
    rocky-8 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ec2-user",
      group        = "wheel",
      name         = "Rocky-8-EC2-Base-8*",
      owner        = "aws-marketplace",
      architecture = "x86_64",
      workfolder   = "~"
    },
    # the goal for these search strings is to keep them as stable as possible without specifying a version that is EOL
    # our users often rely on extended support from RHEL, so we don't consider odd numbered minors which are inelegible for that
    # https://access.redhat.com/support/policy/updates/errata
    # therefore the search found here is the most recent even minor that has been released
    # expect RHEL 9.4 in June 2024
    rhel-9 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "RHEL-9.2.*_HVM-*-x86_64-*-Hourly2-GP3",
      owner        = "amazon",
      architecture = "x86_64",
      workfolder   = "~"
    },
    # following the same lines as rhel-9 this will be the most recent even minor that has been released
    # expect RHEL 8.10 in June 2024
    rhel-8 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "RHEL-8.8.*_HVM-*-x86_64-*-Hourly2-GP3",
      owner        = "amazon",
      architecture = "x86_64",
      workfolder   = "~"
    },
  }
}

```

## Examples

### Local State

The specific use case for the example modules is temporary infrastructure for testing purposes.
With that in mind, it is not expected that we manage the resources as a team, therefore the state files are all stored locally.
If you would like to store the state files remotely, add a terraform backend file (`*.name.tfbackend`) to your root module.
https://www.terraform.io/language/settings/backends/configuration#file

## Development and Testing

### Paradigms and Expectations

Please make sure to read [terraform.md](./terraform.md) to understand the paradigms and expectations that this module has for development.

### Environment

It is important to us that all collaborators have the ability to develop in similar environments,
 so we use tools which enable this as much as possible.
These tools are not necessary, but they can make it much simpler to collaborate.

* I use [nix](https://nixos.org/) that I have installed using [their recommended script](https://nixos.org/download.html#nix-install-macos)
* I use [direnv](https://direnv.net/) that I have installed using brew.
* I simply use `direnv allow` to enter the environment
* I navigate to the `tests` directory and run `go test -v -timeout=40m -parallel=10`
  * It is important to note that the test files do not stand alone, they expect to run as a package.
  * This means that specifying the file to test (as follows) will fail: `go test -v -timeout 40m -parallel 10 basic_test.go`
* To run an individual test I navigate to the `tests` directory and run `go test -v -timeout 40m -parallel 10 -run <test function name>`
  * eg. `go test -v -timeout 40m -parallel 10 -run TestBasic`


Our continuous integration tests in the GitHub [ubuntu-latest runner](https://github.com/actions/runner-images/blob/main/images/linux/Ubuntu2204-Readme.md). It is free for public repositories, we use Nix to add dependencies to it for building and testing.
