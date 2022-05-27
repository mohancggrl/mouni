variable "name" {
  type        = string
  description = "Name of the VPC"
}

variable "environment" {
  type        = string
  description = "Name of Environment this VPC is meant to house"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "availability_zones_public" {
  type        = list
  description = "List of availability zones"
}

variable "availability_zones_dmz" {
  type        = list
  description = "List of availability zones"
}

variable "availability_zones_int" {
  type        = list
  description = "List of availability zones"
}

variable "public_subnet_cidr_blocks" {
  type        = list
  description = "List of public subnet CIDR blocks"
}

variable "dmz_subnet_cidr_blocks" {
  type        = list
  description = "List of private subnet CIDR blocks"
}

variable "int_subnet_cidr_blocks" {
  type        = list
  description = "List of private subnet CIDR blocks"
}

#variable "tags" {
#  type        = map(string)
#  description = "Extra tags to attach to the VPC resources"
#}

variable "vpc_id" {}


