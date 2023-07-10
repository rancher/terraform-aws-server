# storage sizes in GB, using gp3 storage type
locals {
  types = {
    small = {
      id      = "t3.small",
      cpu     = "2",
      ram     = "2",
      storage = "20",
    },
    medium = {
      id      = "m5.large",
      cpu     = "2",
      ram     = "8",
      storage = "200",
    },
    large = {
      id      = "c5.xlarge",
      cpu     = "4",
      ram     = "8",
      storage = "500",
    },
    xl = {
      id      = "t3.xlarge",
      cpu     = "4",
      ram     = "16",
      storage = "1000",
    }
    xxl = {
      id      = "t3.2xlarge",
      cpu     = "8",
      ram     = "32",
      storage = "2000",
    }
  }
}
