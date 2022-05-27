#### EKS ####
variable "cluster_name" {
  type = string
  default = "test"
}

variable "subnet_ids" {
  type = list(string)
  default = ["subnet-04406daacad859c9d", "subnet-0992ab19bfa4dd25c"]
}

#### EKS_Nodes ####
variable "worker_name" {
  default = "test_worker"
}

variable "desired_size" {
  type = number
  default = 2
}

variable "max_size" {
  type = number
  default = 2
}

variable "min_size" {
  type = number
  default = 1
}

variable "ami_type" {
  type = string
  default = "AL2_x86_64"
}

variable "instance_types" {
  type = string
  default = "t2.micro"
}