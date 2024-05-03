# Direct SSH Access over EIP

The expands on the basic example by enabling direct access to the server through the network, and by enabling ssh access on the OS.
The exposure mechanism is specifically through an elastic IP address.

The goal of this example is to show how you could enable ssh access on a server, complete with a new user and ssh key.
There are many ways to set up ssh access, but this one attempts to be as secure as possible
 by making sure that no private key is listed in the state file and only a single IP is allowed access to the server.

From a higher level, this is very similar to how you would set up a server for our install modules.
