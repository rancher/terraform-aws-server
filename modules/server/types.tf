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
