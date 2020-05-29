version = "v1"

variable "region" {
  policy = "cloud.locations"
  conditions = {
  cloud = "ec2"
  }
}

variable "vpc" {
  policy = "cloud.networks"
  conditions = {
    cloud = "ec2"
    cloud.location = "${var.region}"
  }
}

variable "subnet" {
  policy = "cloud.subnets"
  conditions = {
  cloud = "ec2",
  cloud.location = "${var.region}",
  cloud.network = "${var.vpc}"
  }
}

variable "instance_type" {
  policy = "cloud.instance.types"
  conditions = {
    cloud = "ec2"
  }
}

variable name_prefix {
  global_variable = "name_prefix_fmt"
}
