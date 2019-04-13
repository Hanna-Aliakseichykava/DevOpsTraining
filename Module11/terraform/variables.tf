
variable "region" {}
variable "availability_zone" {}


variable "allowed_cidr_blocks" {
  type = "list"
}

variable "certificate_arn" {}
variable "public_key_path" {}



variable "amis" {
  type = "map"
}

variable "instance_type" {}
variable "autoscaling_group_min_size" {}
variable "autoscaling_group_max_size" {}

