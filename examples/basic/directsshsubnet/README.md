# Direct SSH Access over Public Subnet

The expands on the basic example by enabling direct access to the server through the network, and by enabling ssh access on the OS.
The exposure mechanism is specifically through public IPs that AWS automatically provisions on subnets marked as public.

The goal of this example is to show how you could enable ssh access on a server, complete with a new user and ssh key.
There are many ways to set up ssh access, but this one attempts to be as secure as possible
 by making sure that no private key is listed in the state file and only a single IP is allowed access to the server.

From a higher level, this is how we set up servers for our install modules.
