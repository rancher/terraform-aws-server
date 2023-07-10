# Examples

These are example implementations of this module.
These modules use relative path sourcing so that they can be easily tested by the automation in this repo.
When users implement these modules, they should use the Terraform registry.
Set the source attribute equal to the group and name of the module, and the version to the version you would like to use.
This module *doesn't* install software, use cases are opinionated examples not endorsements, garantees, or warantee.

## Basic

This is a basic end to end example of running the module.
This will provision a small sles15 server.

## Sizes

### Small

This server might be used to run a simple project or simulate an edge device.
This fits the use case for a Pi-Hole.

### Medium

This server might be used to run a small project or simulate a lightweight service.
This fits the use case for a (small) Hashicorp Vault server.

### Large

This server might be used to run a medium sized project or a continuous integration server.
This fits the use case for a GitLab Omnibus with up to 1000 users.

### XL

This server might be used to run a small platform server.
This fits the use case for an RKE2 server in a small cluster.

### XXL

This server might be used to run a shared development environment or a large platform server.
This fits the use case for an RKE2 server running several services.

## Images

### CIS

This is an example of using this module to deploy a Center for Internet Security image suitable for a small RKE2 server.

### RHEL-8

This is an example of using this module to deploy a small Rhel-8 server.

### Rocky-8

This is an example of using this module to deploy a small Rocky-8 server.

### SLES15

This is an example of using this module to deploy a small SLES-15 server.

### Ubuntu 20

This is an example of using this module to deploy a small Ubuntu20 server.

### Ubuntu 22

This is an example of using this module to deploy a small Ubuntu22 server.

## Regions

### Us-West-1

This is an example of using this module to deploy a small SLES15 server in the Us-West-1 region.
Remember that each region needs its own access (vpc, route, gateway, subnet, and security group)

### Us-West-2

This is an example of using this module to deploy a small SLES15 server in the Us-West-2 region.
Remember that each region needs its own access (vpc, route, gateway, subnet, and security group)

### Us-East-1

This is an example of using this module to deploy a small SLES15 server in the Us-East-1 region.
Remember that each region needs its own access (vpc, route, gateway, subnet, and security group)

### Us-East-2

This is an example of using this module to deploy a small SLES15 server in the Us-East-2 region.
Remember that each region needs its own access (vpc, route, gateway, subnet, and security group)

## Overrides

These examples show how to override some parts of the module.
Overrides generally allow us to test internal modules in an isolated way, but sometimes have other benefits.
You can use an override to destroy a resource or to query for a resource without creating it.
