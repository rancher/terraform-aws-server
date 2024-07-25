# Terraform AWS Server

This module deploys infrastructure in AWS.

WARNING! We test in regions us-west-2, us-west-1, us-east-1, and us-east-2.
Our selected image types may not exist in your region, in which case you can select an image manually.
See the examples/select/image for an example of how to do this

## Recent Changes

1. IPv6 Only Support
    To support load balanced IPv6 only instances, the primary interface needs to have the 'primary ipv6 enabled' flag set.
    This flag is not currently available in the Terraform provider, but a PR exists: https://github.com/hashicorp/terraform-provider-aws/pull/36425
    Until the provider supports this flag we are using a workaround.
    The workaround requires the AWS CLI to be installed on the server running Terraform.
    The AWS CLI will use the same authentication mechanisms as Terraform, so there is no need to configure additional credentials.
    WARNING! If deploying with `ip_family = "ipv6"` the server running Terraform must have the AWS CLI installed.
2. Rename images
    - Removed SUSE images that weren't BYOS (bring your own subscription)
      - Amazon subscriptions are harder to automate and don't provide direct service, it ends up being a hidden fee of using the image. Instead, users can use the BYOS image without a subscription until they need one, and then they can add a subscription separately bought from SUSE.
    - Started using SUSE cloud info API to get the latest image names
3. WARNING! Refactor!
    A new Major version and a few new tricks.
    I don't like breaking the interface, but to enable new functionality it made the most sense to refactor.
    - set the private ip for your sever
    - new complex inputs
      - this should improve validation and make code more concise
    - new complex validations
      - using locals I was able to validate complex relationships
    - new "use" paradigm
      - look out for attributes like "server_use_strategy" to enable or disable features
    - indirect access!
      - now you can assign aws lb target group associations when you generate your server

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
  standard_types = {
    sles-15 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "suse-sles-15-sp5-v*-hvm-ssd-x86_64",
      name_regex   = "^suse-sles-15-sp5-v[0-9]+-hvm-ssd-x86_64$",
      owners       = ["013907871322", "679593333241"]
      architecture = "x86_64",
      workfolder   = "~"
    },
    sles-15-byos = { # BYOS = Bring Your Own Subscription, only use this if you have a subscription to SUSE
      user         = "ec2-user",
      group        = "wheel",
      name         = "suse-sles-15-sp5-chost-byos-v*-hvm-ssd-x86_64",        #chost refers to an image that is optimized for running containers
      name_regex   = "^suse-sles-15-sp5-chost-byos-v[0-9]+-hvm-ssd-x86_64$", # we are specifically trying to avoid the -ecs- images
      owners       = ["013907871322", "679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    # WARNING! this AMI requires subscription to a service (not a SUSE subscription),
    #  it is not free https://aws.amazon.com/marketplace/pp/prodview-g5eyen7n5tizm
    sles-15-cis = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "CIS SUSE Linux Enterprise 15 Benchmark - Level 1*",
      name_regex   = "^CIS SUSE Linux Enterprise 15 Benchmark - Level 1.*$",
      owners       = ["679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    sle-micro-55-llc = { # llc refers to SUSE subsidiary incorporation type, in general the LLC images are used in the US and Asia-Pacific
      user         = "suse",
      group        = "wheel",
      name         = "suse-sle-micro-5-5-v*-hvm-ssd-x86_64-llc-*",
      name_regex   = "^suse-sle-micro-5-5-v[0-9]+-hvm-ssd-x86_64-llc-.*$",
      owners       = ["013907871322", "679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    }
    sle-micro-55-ltd = { # ltd refers to SUSE subsidiary incorporation type, in general the LTD images are used in the Europe, the Middle East, and Africa (EMEA)
      user         = "suse",
      group        = "wheel",
      name         = "suse-sle-micro-5-5-v*-hvm-ssd-x86_64-ltd-*",
      name_regex   = "^suse-sle-micro-5-5-v[0-9]+-hvm-ssd-x86_64-ltd-.*$",
      owners       = ["013907871322", "679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    }
    sle-micro-55-byos = { # BYOS = Bring Your Own Subscription, only use this if you already have a subscription to SUSE
      user         = "suse",
      group        = "wheel",
      name         = "suse-sle-micro-5-5-byos-v*-hvm-ssd-x86_64",
      name_regex   = "^suse-sle-micro-5-5-byos-v[0-9]+-hvm-ssd-x86_64$",
      owners       = ["013907871322", "679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    }
    # WARNING! this AMI requires subscription to a service (not a SUSE subscription),
    #   it is not free https://aws.amazon.com/marketplace/server/procurement?productId=ca1fe94d-9237-41c7-8fc8-78b6b0658c9f
    rhel-8-cis = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "CIS Red Hat Enterprise Linux 8 Benchmark - STIG*",
      name_regex   = "^CIS Red Hat Enterprise Linux 8 Benchmark - STIG.*$",
      owners       = ["679593333241"],
      architecture = "x86_64",
      workfolder   = "/var/tmp"
    },
    ubuntu-20 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-2024*-*",
      name_regex   = "^ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-2024.*-.*$",
      owners       = ["679593333241", "099720109477", "513442679011", "837727238323"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    ubuntu-22 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ubuntu",
      group        = "admin",
      name         = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-2024*-*",
      name_regex   = "^ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-2024[0-9]+-.*$", # specifically avoiding .1 images eg. ubuntu-jammy-22.04-amd64-server-20240207.1-47489723-7305-4e22-8b22-b0d57054f216
      owners       = ["679593333241", "099720109477", "513442679011", "837727238323"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    rocky-8 = { # WARNING! you must subscribe and accept the terms to use this image
      user         = "ec2-user",
      group        = "wheel",
      name         = "Rocky-8-EC2-Base-*.x86_64-*",
      name_regex   = "^Rocky-8-EC2-Base-.*.x86_64-.*$",
      owners       = ["679593333241"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    liberty-7 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "suse-liberty-7-9-byos-v*-x86_64",
      name_regex   = "^suse-liberty-7-9-byos-v[0-9]+-x86_64$",
      owners       = ["013907871322"],
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
      name         = "RHEL-9.3*_HVM-2024*-x86_64-*-Hourly2-GP3",
      name_regex   = "^RHEL-9.3.*_HVM-2024.*-x86_64-.*-Hourly2-GP3$",
      owners       = ["309956199498"],
      architecture = "x86_64",
      workfolder   = "~"
    },
    # following the same lines as rhel-9 this will be the most recent even minor that has been released
    # expect RHEL 8.10 in June 2024
    rhel-8 = {
      user         = "ec2-user",
      group        = "wheel",
      name         = "RHEL-8.9*_HVM-2024*-x86_64-*-Hourly2-GP3",
      name_regex   = "^RHEL-8.9.*_HVM-2024.*-x86_64-.*-Hourly2-GP3$",
      owners       = ["309956199498"],
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
