#### EKS ####
variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

#### EKS_Nodes ####
variable "worker_name" {
  type = string
}

variable "desired_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "ami_type" {
  type = string
}

variable "instance_types" {
  type = string
}

variable "aws_vpc" {
  type = string
}


